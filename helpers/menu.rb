module Sinatra
  module MenuHelper
    def get_menus(dir, order = nil)
      Dir.entries(dir).map do |f|
        unless f =~ /^\./
          if File.directory? File.join(dir, f)
            { f => get_menus(File.join(dir, f)) }
          else
            m = /^(.+)\.haml/.match(f)
            if m
              m[1]
            end
          end
        end
      end.select { |e| e }
    end

    def sort_menus(menus)
      menus.sort do |a, b|
        a = a.keys[0] if a.class == Hash
        b = b.keys[0] if b.class == Hash
        a <=> b
      end
    end

    def format_menu_name(m)
      m.gsub(/_/, " ").split(/ /).map { |w| w.capitalize }.join(' ')
    end
  end

  helpers MenuHelper
end
