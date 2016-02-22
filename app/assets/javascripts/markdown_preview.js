(function(){

    /**
     * Minikniznica, ktora umoznuje zobrazovat nahlad obsahu textarea elementu formularov.
     * */
    function MarkdownPreview(textarea, opts) {

        this.id = "markdown-preview"+MarkdownPreview.counter;
        this.isPreviewed = false;
        this.textarea = textarea;

        this.options = $.extend({
            autofix: false,
            autosize: true,
            className: '',
            outerClassName: '',
            showAlways: false
        }, opts);

        MarkdownPreview.counter++;

        if (this.options.autosize) {
            autosize(this.textarea);
            this.textarea.on('focus', function(){
                autosize.update(this.textarea);
            }.bind(this));
        }

        this.init();

        // Zmensime textarea prvok.
        if (this.options.autofix) {

            // Budeme cakat, az kym sa element nevykresli.
            this.waitInterval = setInterval(function(){

                if (this.textarea.is(':visible')) {

                    var diff = this.textarea.innerWidth() - this.wrapper.innerWidth();
                    var newWidth = this.textarea.width() - diff;
                    this.textarea.width(newWidth);
                    this.previewAreaInner.width(newWidth);

                    clearInterval(this.waitInterval);

                }

            }.bind(this), 100);

        }

    }

    MarkdownPreview.prototype = {

        /** Inicializuje MarkdownPreview. */
        init: function() {

            // Obalime textarea prvok do divu.
            $(this.textarea).wrap('<div id="'+this.id+'" class="markdown-preview '+(this.options.outerClassName)+'"></div>');
            this.wrapper = $('#'+this.id);

            this.button = $('<div class="btn preview-toggle">'+MarkdownPreview.showText+'</div>');

            this.button.click(function(){

                if (this.isPreviewed) {
                    this.hidePreview();
                }
                else {
                    this.loadPreview();
                }

            }.bind(this));

            this.previewArea = $('<div class="preview-area"></div>');
            this.previewAreaInner = $('<div class="preview-area-inner'+(this.options.className ? ' '+this.options.className:'')+'"></div>');
            this.previewArea.append(this.previewAreaInner).click(function(){
                this.hidePreview();
                this.textarea.focus();
            }.bind(this));

            this.wrapper.append(this.button);
            this.wrapper.append(this.previewArea);

        },

        /** Vyvola nacitanie ukazky. */
        loadPreview: function() {

            if (this.isPreviewed) {
                return false;
            }

            this.isPreviewed = true;

            $.ajax({
                url: '/markdown/preview',
                type: 'post',
                data: { text: this.textarea.val() }
            }).success(function(resp) {

                this.button.html(MarkdownPreview.hideText).addClass('active');
                this.previewAreaInner.html(resp).height(this.textarea.height());
                this.previewArea.show();

            }.bind(this)).error(function(){
                this.isPreviewed = false;
            }.bind(this));

        },

        /** Vyvola skrytie ukazky. */
        hidePreview: function() {

            if (!this.isPreviewed) {
                return false;
            }

            this.isPreviewed = false;
            this.button.html(MarkdownPreview.showText).removeClass('active');
            this.previewArea.hide();

        }

    };

    MarkdownPreview.counter = 1;
    MarkdownPreview.showText = "Ukážka";
    MarkdownPreview.hideText = "Skryť ukážku";

    window.MarkdownPreview = MarkdownPreview;

})();