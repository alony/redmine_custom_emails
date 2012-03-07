class EmailTemplate < ActiveRecord::Base
  named_scope :sterling, :conditions => "action REGEXP '^[a-z]'"
  named_scope :by_lang, lambda{|lang| 
    lang=I18n.default_locale if lang.blank?
    {:conditions => {:locale => lang.to_s}}
  }
  
  before_save do |record|
    record.text = record.html.gsub /<[^>]*>/, '' if record.html_changed?
  end
  
  CODE = /\^%([^%]*)%\^/
  VAR  = /\:!!([^!]*)!!\:/
  
  def short_text
    text_preview.length > 200 ? text_preview.first(200) << '...' : text_preview
  end

  def text_preview
    text.gsub(CODE, "<code>").gsub(VAR, "<variable>")
  end
  
  def code_escaped
    html.gsub(CODE, '<span class="code escape">\1</span>').gsub(VAR, '<span class="vars escape">\1</span>')
  end
end
