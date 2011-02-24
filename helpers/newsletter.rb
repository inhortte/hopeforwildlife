module Sinatra
  module NewsletterHelper
    # They will be like this: { year => [page1.pdf, page2.pdf,...] }
    def get_newsletters
      article_dir = "public/articles"
      newsletters = { }
      Dir.entries(article_dir).each do |f|
        m = /^newsletter_(\d+)_\d+\.pdf$/.match(f)
        if m
          if newsletters.has_key? m[1]
            newsletters[m[1]].push(m[0])
          else
            newsletters[m[1]] = [ m[0] ]
          end
        end
      end
      newsletters.each_key do |k|
        newsletters[k].sort!
      end
    end
  end

  helpers NewsletterHelper
end
