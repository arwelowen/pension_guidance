class HomeController < ApplicationController
  layout 'home'

  def show
    expires_in Rails.application.config.cache_max_age, public: true
  end

  def home_alt_1; end
  def home_alt_2; end

  def footer?
    false
  end
end
