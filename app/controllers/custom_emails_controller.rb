class CustomEmailsController < ApplicationController
  layout 'admin'
  unloadable
  
  helper_method :l
  
  def index
    @emails = EmailTemplate.sterling.by_lang(User.current.language)
  end
  
  def edit
    @email = EmailTemplate.find_by_id params[:id]
  end
  
  protected
  def l *args
    Redmine::I18n.l *args
  end
end
