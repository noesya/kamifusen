# frozen_string_literal: true
module Kamifusen
  module ViewHelper
    def kamifusen_tag(source, options = {})
      render "kamifusen/view", source: source, options: options
    end
  end
end
