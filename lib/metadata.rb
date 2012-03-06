module MetaData
  def all_actions
    return @all if @all
    
    @all = Redmine::Notifiable.all.map{ |n| n.name.to_sym }
    @all.map!{|notifier| view_aliases[notifier] || notifier}.uniq!
  end
    
  def view_aliases
    @view_aliases ||= {:issue_added => :issue_add,
                       :issue_updated => :issue_edit,
                       :issue_note_added => :issue_edit,
                       :issue_status_updated => :issue_edit,
                       :issue_priority_updated => :issue_edit,
                       :file_added => :attachments_added }
  end
    
  def email_locales
    @locales ||= [:en]
  end
    
  # configurable options
  def additional_view_aliases= val
    view_aliases.merge! val
  end

  def additional_locales= *val
    val.each{ |l| email_locales << l}
  end
end

module TemplatesData
  def available_templates
    all(:select => "action, locale").map{ |t| "#{t.locale}.#{t.action}" }
  end
end
EmailTemplate.send(:extend, TemplatesData)
