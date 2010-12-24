module Sinatra
  module MenuHelper
    def get_menus(dir, order = nil)
      entries = Dir.entries(dir) rescue []
      entries.map do |f|
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

    def immediate_submenus(menus, page)
      submenus = []
      menus.each do |sm|
        if sm.is_a? Hash
          if get_menu_name(sm) == page
            submenus = sm[page].map do |ssm|
              get_menu_name ssm
            end
            break
          else
            search_submenu = immediate_submenus(sm[sm.keys[0]], page)
            submenus = search_submenu if !search_submenu.blank?
            break
          end
        end
      end
      submenus
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
