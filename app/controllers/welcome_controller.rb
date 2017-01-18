class WelcomeController < ApplicationController
  skip_before_filter :store_target_location
  def index
  end
end
