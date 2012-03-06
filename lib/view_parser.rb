require 'erb'
include Redmine::I18n

module Redmine::CustomEmails
  class Parser
    include ERB::Util
    include ActionView::Helpers
    
    def initialize(file_path)
      @data = File.read(file_path)
    end

    def delimiters
      %w(\} \) , \s).join("|")
    end

    def replace_vars
      @data.gsub!(/(@[^#{delimiters}]*)/, '":!!\1!!:"')
    end

    def render
      replace_vars
      ERB.new(@data).result(binding)
    end
    
    def l *args
      Redmine::I18n.l *args
    end
  end

end
