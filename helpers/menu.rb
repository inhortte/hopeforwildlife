module Sinatra
  module MenuHelper
    def get_menus(dir, order = nil)
      Dir.entries(dir).map do |f|
        m = /^(.+)\.haml/.match(f)
        if m
          menu = m[1]
          if File.directory? File.join(dir, menu)
            { menu => get_menus(File.join(dir, menu)) }
          else
            menu
          end
        end
      end.select { |m| m }
    end

    def sort_menus(menus)
      menus.sort do |a, b|
        a = a.keys[0] if a.is_a? Hash
        b = b.keys[0] if b.is_a? Hash
        a <=> b
      end
    end

    def format_menu_name(m)
      m.gsub(/_/, " ").split(/ /).map { |w| w.capitalize }.join(' ')
    end

    def get_menu_name(m)
      (m.is_a? Hash) ? m.keys[0] : m
    end
  end

  helpers MenuHelper
end
