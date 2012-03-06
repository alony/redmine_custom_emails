#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|
  
  map.resources :custom_emails
  
  
#  map.resources :todos, :name_prefix => 'user_', :path_prefix => '/users/:user_id', :controller => :mytodos,
#    :member => {:toggle_complete => :post }, :collection => {:sort => :post}
  

end
