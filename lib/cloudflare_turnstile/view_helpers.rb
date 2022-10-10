# frozen_string_literal: true

module CloudflareTurnstile
  module ViewHelpers

    # Builds the Turnstile html
    #
    # @return [String] the generated html
    def cloudflare_turnstile
      content_tag(:div, class: css_class) do
        concat script_tag
        concat turnstile_div
      end
    end

    private

    def script_tag
      content_tag(:script, src: js_src, "async" => true, "defer" => true) do
        ""
      end
    end

    def turnstile_div
      content_tag(:div, class: "cf-turnstile", "data-sitekey" => site_key) do
        ""
      end
    end

    def site_key
      ENV["CLOUDFLARE_TURNSTILE_SITE_KEY"]
    end

    def js_src
      "https://challenges.cloudflare.com/turnstile/v0/api.js"
    end

    def css_class
      "cloudflare-turnstile"
    end
  end
end
