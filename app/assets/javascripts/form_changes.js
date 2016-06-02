(function(){

    /**
     *
     * */
    function FormChanges(itemIdentifier, url, method) {

        this.itemIdentifier = itemIdentifier;
        this.url = url;
        this.method = method;
        this.changes = {};

        this.queue = [];

        this.resetStats();

        this.bindings = {
            change: [],
            keyup: [],
            updateStarted: [],
            updateNext: [],
            updateErrored: [],
            updateFinished: []
        };

        this.init();

    }

    FormChanges.prototype = {

        /**
         * Inicializuje sledovac zmien vo formulari.
         * */
        init: function() {

            var _this = this;

            this.itemIdentifier.each(function() {

                var id = $(this).attr('data-object-id');

                var changeFn = function(e) {

                    var name = e.attr('data-attr');
                    var value = $('input[name="'+e.attr('name')+'"]').val();
                    if (e.attr('type') == "checkbox" && !e.prop('checked')) {
                        value = null;
                    }

                    if (!_this.changes[id]) {
                        _this.changes[id] = {};
                    }

                    _this.changes[id][name] = value;

                };

                $(this).find('input[data-attr],select[data-attr],textarea[data-attr]').change(function(){
                    changeFn($(this));
                    _this.call('change', [_this]);
                }).keyup(function(){
                    changeFn($(this));
                    _this.call('keyup', [_this]);
                });

            });

        },

        resetStats: function() {
            this.stats = {
                changes: 0,
                success: 0,
                errors: 0
            };
        },

        on: function(type, fn) {
            var types = type.split(',');
            for(var i=0; i<types.length; i++) {
                this.bindings[types[i]].push(fn);
            }
            return this;
        },

        call: function(type, params) {
            var types = type.split(',');
            for(var i=0; i<types.length; i++) {
                for(var j=0; j<this.bindings[types[i]].length; j++) {
                    this.bindings[types[i]][j].apply(null, params);
                }
            }
        },

        /**
         * Odosle vsetky zmeny vo formulari.
         * */
        submit: function(input) {

            $(input).prop('disabled', true);
            this.input = input;

            this.resetStats();

            // Vytvorime queue, do ktorej postupne vlozime vsetky zmeny.
            $.each(this.changes, function(id, data){

                this.queue.push($.extend({
                    id: id
                }, data));

            }.bind(this));

            this.queueSize = this.getChangesCount();

            this.call('updateStarted', [this]);

            this.checkQueue();

        },

        checkQueue: function() {

            if (this.queue.length > 0) {
                this.deque();
            }
            else {
                this.call('updateFinished', [this, this.stats]);

                if(this.input) {
                    $(this.input).prop('disabled', false);
                    this.input = null;
                }
            }

        },

        deque: function() {

            var data = this.queue.pop();

            var url = this.url.replace('_OBJECT_ID_', data.id);

            var method = this.method.toLowerCase();
            if (method != "get" && method != "post") {
                data['_method'] = method;
                method = "post";
            }

            $.ajax({
                url: url,
                method: method,
                data: data
            }).success(function(){
                delete this.changes[data.id];
                this.stats.success++;
            }.bind(this)).error(function(){
                this.call('updateErrored', [this, data]);
                this.stats.errors++;
            }.bind(this)).always(function(){
                this.call('updateNext', [this, this.queue]);
                this.checkQueue();
            }.bind(this));

        },

        /**
         * Vrati pocet poloziek v queue.
         * */
        getQueueSize: function() {
            return Object.keys(this.queue).length;
        },

        /**
         * Vrati pocet zmenenych instancii formulara.
         * */
        getChangesCount: function() {
            return Object.keys(this.changes).length;
        },

        /**
         * Ziska aktualny percentualny stav ukladania.
         * */
        getQueueStatus: function() {
            return (1 - this.getQueueSize() / this.queueSize);
        }


    };

    window.FormChanges = FormChanges;

})();