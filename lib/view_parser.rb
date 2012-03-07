require 'erb'
include Redmine::I18n

module Redmine
  module CustomEmails
    class Parser
      include ERB::Util
      include ActionView::Helpers
    
      def initialize(file_path, loc)
        @data = File.read(file_path)
        @locale = loc.to_s
      end

      def delimiters
        %w(\= \( \{ \} \) , \s).join
      end

      def replace_vars!
        @data.gsub!(/!%([^%]*)%!/) do
          "<%#{$1.gsub(/(@[^#{delimiters}]*)/, '":!!\1!!:"')}%>"
        end
      end

      def escape_erb!
        # save all +t+ and +l+ lines to render them later
        @data.gsub!(/<%(=\s*[lt]\s?\([^%]*)%>/, '!%\1%!')
        
        # put partials instead of +render+ lines
        @data.gsub!(/<%(=\s*render[^\"]*"([^\.]*).*(\{.*\})[^%]*)%>/) do |str|
           partial_name =  "_" + $2
           partial_text = EmailTemplate.find_by_action_and_locale(partial_name, @locale).try(:html)
           locals = eval $3.gsub(/(@[^#{delimiters}]*)/, '"\1"') rescue {}

           raise LoadError unless partial_name
           locals.each_pair do |local, global|
             4.times {partial_text.gsub!(/(\^%[^%]*[#{delimiters}])#{local}([#{delimiters}.])/, '\1' << global << '\2')}
           end
           
           partial_text
        end
        
        # save all erb data as is
        @data.gsub!(/<%([^%]*)%>/, '^%\1%^')
        
        # escape variables in +l+ and +t+ and make them processable
        replace_vars!
      end
      
      def render
        escape_erb!
        ERB.new(@data).result(binding)
      end
      
      def l *args
        Redmine::I18n.l *args
      end
    end
  end

end

