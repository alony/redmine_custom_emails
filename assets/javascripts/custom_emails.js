var EmailArea = {
  init: function() {
    EmailArea.spans_ineditable();
  },

  el: "div#custom_email_edit",
  html_data: "textarea#email_template_html",
  
  spans_ineditable: function() {
    jQuery(EmailArea.el).find("span.escape").live("click", function() {
    alert("ui");
      p = jQuery(this).parent();
      setCursor(p, 1);
      return false;
    })
  }
}

jQuery.noConflict();
jQuery(document).ready(EmailArea.init);


