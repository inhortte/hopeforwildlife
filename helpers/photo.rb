module Sinatra
  module PhotoHelper
    # refactor this! it is awful.
    def get_random_photos(n, photo_dir = 'animals')
      photo_dir = 'animals' if !Dir.entries('public/images').include?(photo_dir)

      pics = []
      unless photo_dir == 'animals'
        files = Dir.entries("public/images/#{photo_dir}").select do |f|
          f =~ /^.+\.(jpg|JPG|gif|png)$/
        end
        pics = pics + 1.upto(n > files.size ? files.size : n).inject([]) do |photos, unused|
          photos.push(File.join(photo_dir, files.delete_at(rand(files.size))))
        end
      else
        extra_photos_dirs = ['dos_and_donts', 'how_to_catch_and_transport',
                             'living_with_wildlife', 'sponsor_an_animal']
        if pics.size < n
          epd = extra_photos_dirs[rand(extra_photos_dirs.size)]
          files = Dir.entries("public/images/#{epd}").select do |f|
            f =~ /^.+\.(jpg|JPG|gif|png)$/
          end
          pics = pics + pics.size.upto(n - 1).inject([]) do |photos, unused|
            photos.push(File.join(epd, files.delete_at(rand(files.size))))
          end
        end
      end
      pics
    end
  end

  helpers PhotoHelper
end
