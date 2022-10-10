# frozen_string_literal: true

module CloudflareTurnstile
  class Railtie < Rails::Railtie
    initializer "cloudflare_turnstile.rails_integration" do
      ActiveSupport.on_load(:action_controller) do
        include CloudflareTurnstile::ControllerExt
        extend CloudflareTurnstile::ControllerExt::ClassMethods
      end

      ActiveSupport.on_load(:action_view) do
        include CloudflareTurnstile::ViewHelpers
      end
    end
  end
end
