module Sinatra
  module BlueclothHelper
    def from_blue_cloth(bc)
      BlueCloth.new(bc).to_html
    end
  end

  helpers BlueclothHelper
end
