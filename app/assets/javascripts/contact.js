    var Contact = {
  div : null,
  ctaBtn : null,
  cancelBtn : null,
  sendBtn : null,
  textarea : null,

  init : function() {
      this.div = $('#contact');
      this.ctaBtn = $('#contact-btn');
      this.cancelBtn = $('#contact-cancel-btn');
      this.sendBtn = $('#contact-send-btn');
      this.textarea = $('#contact textarea')

      this.ctaBtn.click(function() {
        Contact.show();
      });

      this.sendBtn.click(function() {
          Contact.hide();
      });

      this.cancelBtn.click(function() {
          Contact.hide();
          return false; // Zabrani odosielaniu formulara
      });
  },

  show : function() {
      Contact.div.css('bottom',0);
      Contact.textarea.focus();
  },

  hide : function() {
      Contact.div.css('bottom','100%');
  }


};