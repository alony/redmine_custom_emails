class EmailTemplate < ActiveRecord::Base

  before_save do |record|
    record.text = record.html if record.html_changed?
  end

  def short_text
    text.first(200) << '...' if text
  end

end
