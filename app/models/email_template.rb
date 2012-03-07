class EmailTemplate < ActiveRecord::Base

  named_scope :sterling, :conditions => "action like '_*'"

  before_save do |record|
    record.text = record.html.gsub /<[^>]*>/, '' if record.html_changed?
  end

  def short_text
    text.first(200) << '...' if text
  end

end
