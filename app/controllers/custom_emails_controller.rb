class CustomEmailsController < ApplicationController
  layout 'admin'
  unloadable
  
  def index
    @email_pages, @emails = paginate EmailTemplate.sterling, :per_page => 10, :order => 'action'
  end
end
