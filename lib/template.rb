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

        #first process partials, then actions
        [/^_/, /^[^_]/].each do |exp|
          email_locales.reverse.each do |loc|
            I18n.locale = loc
            all_actions.each_pair do |action, path|
              next unless action =~ exp

              puts action.inspect
              unless @templates.include? "#{loc}.#{action}"
                EmailTemplate.create(:action => action, :locale => loc.to_s, :html => Parser.new(path).render)
              end
            end
          end
        end
        
        I18n.locale = I18n.default_locale
      end
    end

  end
end

