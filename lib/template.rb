require 'metadata'
require 'view_parser'

module Redmine::CustomEmails
  module Template

    class << self
      include MetaData

      def init
        @templates = EmailTemplate.available_templates
        
        # init external configuration        
        yield self if block_given?
     
        email_locales.each do |locale|
          all_actions.each_pair do |action, path|
            unless @templates.include? "#{locale}.#{action}"
              
              
              #EmailTemplate.create(:action => action, :locale => locale)
            end
          end
        end
        puts Parser.new(all_actions["account_information"]).render
      end
    end

  end
end

