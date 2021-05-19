# frozen_string_literal: true

require "kamifusen/version"
require "kamifusen/railtie"
require "kamifusen/view_helper"

module Kamifusen
  class Engine < ::Rails::Engine
  end
  class Error < StandardError
  end
end
