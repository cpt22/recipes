class AccountController < ApplicationController
  layout :default_layout
  before_action :authenticate_user!

  def index
  end
end