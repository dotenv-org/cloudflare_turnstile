# cloudflare_turnstile

Add [Cloudflare Turnstile](https://blog.cloudflare.com/turnstile-private-captcha-alternative/) to your Rails app in seconds.

[![Gem](https://img.shields.io/gem/v/cloudflare_turnstile.svg?style=flat-square)](https://rubygems.org/gems/cloudflare_turnstile)

## Installation

Add this line to your Gemfile and then execute bundle install:

```ruby
gem "cloudflare_turnstile"
```

## Usage

Add the view helper to your form - just before the submit button is usually a good spot.

```erb
<%= form_for(@user) do |f| %>
  ..
  <%= cloudflare_turnstile %>
  <%= f.submit "Log In" %>
<% end %>
```

Then enable it for the controller actions you wish. It works just like a `before_action`. Pass `only:` with the action names.

```ruby
class UsersController < ApplicationController
  cloudflare_turnstile only: [:create, :login_submit]

  def new
    # new user view
  end

  def create
    # Turnstile verification will automatically take place prior to here.

    @user = User.create!(params)
    ..
  end

  def login
    # login form view
  end

  def login_submit
    # Turnstile verification will automatically take place prior to here.

    ..
  end
end
```

By default, it responds with no content (only headers: `head(200)`). This way the spam bot thinks they have been successful and will spend less time making requests to your website.

## Credits

Inspiration [invisible_captcha](https://github.com/markets/invisible_captcha)
