# frozen_string_literal: true

module CloudflareTurnstile
  module ControllerExt
    module ClassMethods
      # Enables Turnstile on a controller action
      #
      #
      def cloudflare_turnstile(options = {})
        before_action(options) do
          cloudflare_turnstile_verify(options)
        end
      end
    end

    private

    def cloudflare_turnstile_verified?(options = {})
      url = URI(cloudflare_turnstile_verify_url)
      secret = cloudflare_turnstile_secret_key
      response = params["cf-turnstile-response"]

      res = Net::HTTP.post_form(url, secret: secret, response: response)
      json = JSON.parse(res.body)

      success = json["success"]

      return true if success

      error = json["error-codes"][0]

      cloudflare_turnstile_warn_spam(error)

      false
    end

    def cloudflare_turnstile_verify(options = {})
      if cloudflare_turnstile_verified?(options)
        true
      else
        head(200) # respond with no content and 200 since the bot will think it has submitted properly
      end
    end

    def cloudflare_turnstile_verify_url
      "https://challenges.cloudflare.com/turnstile/v0/siteverify"
    end

    def cloudflare_turnstile_warn_spam(message)
      logger.warn("Spam detected for IP #{request.remote_ip}. #{message}")

      ActiveSupport::Notifications.instrument(
        "cloudflare_turnstile.spam_detected",
        message: message,
        remote_ip: request.remote_ip,
        user_agent: request.user_agent,
        controller: params[:controller],
        action: params[:action],
        url: request.url,
        params: request.filtered_parameters
      )
    end

    def cloudflare_turnstile_secret_key
      ENV["CLOUDFLARE_TURNSTILE_SECRET_KEY"]
    end
  end
end
