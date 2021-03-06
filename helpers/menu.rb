require 'yaml'

module Sinatra
  module MenuHelper
    def get_menus(dir, order = nil)
      entries = YAML::load(File.open(File.join(dir, 'order.yml'))) rescue []
      entries.map do |menu|
        if File.directory? File.join(dir, menu)
          { menu => get_menus(File.join(dir, menu)) }
        else
          menu
        end
      end
    end

=begin
Here's the old version.
    def get_menus(dir, order = nil)
      entries = Dir.entries(dir) rescue []
      entries.map do |f|
        m = /^\d?\d?_?(.+)\.haml$/.match(f)
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
=end

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
            unless search_submenu.blank?
              submenus = search_submenu
              break
            end
          end
        end
      end
      submenus
    end

    # This is a bit arbitrary. I am asuming there will never be
    # more than 2 columns, though I may be deadly wrong at some
    # point in my irascable future. We shall see.
    # And, oouh, baby, this is hackish.
    def organize_columns(submenus, column_headers = nil)
      if column_headers
        ch_keys = column_headers.keys
        one = submenus.select do |submenu|
          column_headers[ch_keys[0]].match(submenu)
        end
        two = submenus.select do |submenu|
          column_headers[ch_keys[1]].match(submenu)
        end
      else
        ch_keys = [ 1, 2 ]
        one, two = (submenus.size == 1 ? [submenus,[]] : [submenus[0..(submenus.size / 2 - 1 + submenus.size % 2)], submenus[(submenus.size / 2 + submenus.size % 2)..-1]])
      end
      { ch_keys[0] => one, ch_keys[1] => two }
    end

    def sort_menus(menus)
      menus
#      menus.sort do |a, b|
#        a = a.keys[0] if a.is_a? Hash
#        b = b.keys[0] if b.is_a? Hash
#        a <=> b
#      end
    end

    def format_menu_name(m)
      m.split(/_/).map do |w|
        if w.all? { |c| c == c.downcase }
          w.capitalize
        else
          w
        end
      end.join(' ')
    end

    def format_menu_name_for_title(m)
      format_menu_name(m).gsub(' ', '<br />')
    end

    def get_menu_name(m)
      (m.is_a? Hash) ? m.keys[0] : m
    end

    def spelling_anomaly?(menu)
      anomaly? menu, { 'dos_and_donts' => "Dos And Don'ts" }
    end

    def path_anomaly?(menu)
      anomaly? menu, { 'volunteer' => '/pages/programs/volunteer' }
    end

    def anomaly?(menu, anomalies)
      if anomalies.keys.include? menu
        anomalies[menu]
      else
        nil
      end
    end
  end

  helpers MenuHelper
end
