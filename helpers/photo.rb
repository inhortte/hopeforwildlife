module Sinatra
  module PhotoHelper
    def get_random_photos(n, photo_dir = 'animals')
      photo_dir = 'animals' if !Dir.entries('public/images').include?(photo_dir)
      files = Dir.entries("public/images/#{photo_dir}").select do |f|
        f =~ /^.+\.(jpg|JPG|gif|png)$/
      end
      1.upto(n).inject([]) do |photos, unused|
        photos.push(File.join(photo_dir, files.delete_at(rand(files.size))))
      end
    end
  end

  helpers PhotoHelper
end
