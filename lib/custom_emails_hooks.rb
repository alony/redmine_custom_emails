# This class hooks into Redmine's View Listeners in order to add content to the page
class CustomEmailsHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    css = stylesheet_link_tag 'custom_emails.css', :plugin => 'redmine_custom_emails'
    js = [javascript_include_tag('jquery.1.7.1.min.js', :plugin => 'redmine_custom_emails'), javascript_include_tag('custom_emails.js', :plugin => 'redmine_custom_emails')].join
    css + js
  end
end
