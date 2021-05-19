# frozen_string_literal: true
module Kamifusen
  module ViewHelper
    def kamifusen_tag(source, options = {})
      image_tag(source, options)
    end
  end
end
