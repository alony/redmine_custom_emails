require 'erb'
include Redmine::I18n

module Redmine
  module CustomEmails
    class Parser
      include ERB::Util
      include ActionView::Helpers
    
      def initialize(file_path)
        @data = File.read(file_path)
      end

      def delimiters
        %w(\= \( \{ \} \) , \s).join
      end

      def replace_vars!
        @data.gsub!(/!%(.*)%!/) do
          "<%#{$1.gsub(/(@[^#{delimiters}]*)/, '":!!\1!!:"')}%>"
        end
      end

      def escape_erb!
        # save all +t+ and +l+ lines to render them later
        @data.gsub!(/<%(=\s*[lt]\s?\([^%]*)%>/, '!%\1%!')
        
        # put partials instead of +render+ lines
        @data.gsub!(/<%(=\s*render[^\"]*"([^\.]*).*(\{.*\})[^%]*)%>/) do |str|
           partial_name =  "_" + $2
           puts "partial_name: #{partial_name}"
           
           partial_text = EmailTemplate.find_by_action(partial_name).try(:html)
           puts "partial_text: #{partial_text}"

           locals = eval $3.gsub(/(@[^#{delimiters}]*)/, '"\1"') rescue {}
           puts "locals: #{locals.inspect}"
           
           raise LoadError unless partial_name
           locals.each_pair do |local, global|
             4.times {partial_text.gsub!(/(\^%[^%]*[=\(\{\}\),\s])#{local}([\=\(\{\}\),\s\.])/, '\1' << global << '\2')}
           end
           
           partial_text
        end
        
        # save all erb data as is
        @data.gsub!(/<%([^%]*)%>/, '^%\1%^')
        
        replace_vars!
      end
      
      def render
        escape_erb!
        puts @data.inspect
        ERB.new(@data).result(binding)
      end
      
      def l *args
        Redmine::I18n.l *args
      end
    end
  end

end

