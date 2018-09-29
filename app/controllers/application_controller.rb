class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # Make sessions helper functions available in ALL controllers
  include SessionsHelper
end
