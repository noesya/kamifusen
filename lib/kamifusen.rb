# frozen_string_literal: true

require "kamifusen/version"
require "kamifusen/railtie"
require "kamifusen/view_helper"

module Kamifusen

  mattr_accessor :with_webp
  @@with_webp = true

  mattr_accessor :sizes
  @@sizes = [
    # 360, # Old android
    375, # Old iPhone
    # 414, # ?
    576, # Tablets desktop
    640, # iPhone SE, some tablets
    750, # iPhone 6/7/8, 375@2x
    768, # Old iPads, Old desktops
    # 828, # ?
    # 992, # Breakpoint bootstrap
    1080, # iPhone 6/7/8 plus, 414@2.608 (sorry)
    # 1125, # iPhone 10, 375@3x
    1152,
    # 1172, # iPhone 12, 390@3x
    1200, # Desktop
    1366, # Desktop
    # 1400, # Breakpoint boostrap
    1440, # Samsung Galaxy S20, 360@4x
    1536, # Desktop, some iPads
    1920, # Desktop 2k
    2048, # Some iPad
    2240, # Desktop iMac M1 chipset
    2880, # Desktop MacBook Pro/Air 13" @2x
    3072  # Desktop MacBook Pro 16" @2x
  ]

  mattr_accessor :quality
  @@quality = 75

  class Engine < ::Rails::Engine
  end

  class Error < StandardError
  end
end
