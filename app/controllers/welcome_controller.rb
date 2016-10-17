class WelcomeController < ApplicationController
  def index
    @group = Group.new
  end
end
