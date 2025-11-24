module Kamifusen
  class Railtie < ::Rails::Railtie
    initializer "kamifusen.deprecator", before: :load_environment_config do |app|
      app.deprecators[:kamifusen] = Kamifusen.deprecator
    end

    initializer "kamifusen.view_helpers" do
      ActiveSupport.on_load(:action_view) { include Kamifusen::ViewHelper }
    end
  end
end
