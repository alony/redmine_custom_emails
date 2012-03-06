module Redmine::CustomEmails
  module MetaData
    def all_actions
      @all ||= Mailer.view_paths.map{|path| path.to_s << "/mailer"}.inject({}) do |r, path|
        Dir["#{path}/**/*.html.*"].reject{|name| name[/^_/]}.each do |p|
          p[/\/([^\/]*)\.html/]
          r[$1] = p
        end
        r
      end
    end
    
    def email_locales
      @locales ||= [:en]
    end
    
    # configurable options
    def additional_view_aliases= val
      view_aliases.merge! val
    end

    def additional_locales= *val
      val.each{ |l| email_locales << l}
    end
  end

  module TemplatesData
    def available_templates
      all(:select => "action, locale").map{ |t| "#{t.locale}.#{t.action}" }
    end
  end
  EmailTemplate.send(:extend, TemplatesData)
end
