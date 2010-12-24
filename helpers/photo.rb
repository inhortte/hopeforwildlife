module Sinatra
  module PhotoHelper
    def get_random_photos(n)
      files = Dir.entries("public/images/animals").select do |f|
        f =~ /^.+\.(jpg|JPG|gif|png)$/
      end
      1.upto(n).inject([]) do |photos, unused|
        photos.push(files.delete_at(rand(files.size)))
      end
    end
  end

  helpers PhotoHelper
end
