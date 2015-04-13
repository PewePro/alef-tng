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
          Contact.div.css('bottom',0);
          Contact.textarea.focus();
      });

      this.sendBtn.click(function() {
          Contact.div.css('bottom','100%');
      });

      this.cancelBtn.click(function() {
          Contact.div.css('bottom','100%');
          return false; // Zabrani odosielaniu formulara
      });
  }


};