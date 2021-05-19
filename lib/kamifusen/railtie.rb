module Kamifusen
  class Railtie < ::Rails::Railtie
    initializer "my_gem.view_helpers" do
      ActiveSupport.on_load(:action_view) { include Kamifusen::ViewHelper }
    end
  end
end
