require 'redmine'

require_dependency 'custom_emails_hooks'
require_dependency 'template'
require_dependency 'mailer'

Redmine::Plugin.register :redmine_custom_emails do
  name 'Redmine Custom Emails plugin'
  author 'Alona Mekhovova'
  description 'A plugin for emails text customization for Redmine'
  version '0.0.1.dev'
  url 'https://github.com/alony/redmine_custom_emails'
  author_url 'https://github.com/alony'
  
  Redmine::CustomEmails::Template.init do |config|

    # locales, for which separate email text should be served
    config.additional_locales = :de
  end
  
  menu :admin_menu, :custom_emails, { :controller => 'custom_emails', :action => 'index' }, 
                    :caption => :label_emails_text, :if => Proc.new { User.current.admin }
end


