# This class hooks into Redmine's View Listeners in order to add content to the page
class CustomEmailsHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    stylesheet_link_tag 'custom_emails.css', :plugin => 'redmine_custom_emails'
  end
end
