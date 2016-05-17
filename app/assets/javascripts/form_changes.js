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

        this.stats = {
            changes: 0,
            success: 0
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

                $(this).find('input[data-attr],select[data-attr],textarea[data-attr]').change(function(){

                    var name = $(this).attr('data-attr');
                    var value = $('input[name="'+$(this).attr('name')+'"]').val();
                    if ($(this).attr('type') == "checkbox" && !$(this).prop('checked')) {
                        value = null;
                    }

                    if (!_this.changes[id]) {
                        _this.changes[id] = {};
                    }

                    _this.changes[id][name] = value;
                    console.log(_this.changes);

                });

            });

        },

        /**
         * Odosle vsetky zmeny vo formulari.
         * */
        submit: function(input) {

            $(input).prop('disabled', true);
            this.input = input;

            // Vytvorime queue, do ktorej postupne vlozime vsetky zmeny.
            $.each(this.changes, function(id, data){

                this.queue.push($.extend({
                    id: id
                }, data));

            }.bind(this));

            this.checkQueue();

        },

        checkQueue: function() {

            if (this.queue.length > 0) {
                this.deque();
            }
            else if(this.input) {
                $(this.input).prop('disabled', false);
                this.input = null;
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

            }.bind(this)).error(function(){

                alert("Niečo sa pokazilo. Prosím skúste zmeny uložiť znovu.");

            }).always(function(){
                this.checkQueue();
            }.bind(this));

        }


    };

    window.FormChanges = FormChanges;

})();