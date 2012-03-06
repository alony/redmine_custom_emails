require 'metadata'

module Redmine
  module Template
    class << self
      include MetaData

      def init
        @templates = EmailTemplate.available_templates
        
        # init external configuration        
        yield self if block_given?
        
        available_locales.each do |locale|
          all_actions.each do |action|
            unless @templates.include? "#{locale}.#{action}"
              @views ||= FilesHelper.views
              
            
              #EmailTemplate.create(:action => action, :locale => locale)
            end
          end
        end
        
      end
    end
  end
  
  module FilesHelper
    def self.views
      Mailer.view_paths.map do |path|
        Dir["#{path}/**/*.html.*"].inject({}) do |r, v| 
          action = Template.all_actions.detect {|view| v[view.to_s] }
          r[action] = v if action
          r
        end
      end.inject(&:merge)
    end
  end
end

