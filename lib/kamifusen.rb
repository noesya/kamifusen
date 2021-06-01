# frozen_string_literal: true

require "kamifusen/version"
require "kamifusen/railtie"
require "kamifusen/view_helper"

module Kamifusen

  mattr_accessor :with_webp
  @@with_webp = true

  class Engine < ::Rails::Engine
  end

  class Error < StandardError
  end
end
