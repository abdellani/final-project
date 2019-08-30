# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def owner?(owner)
    return if owner == current_user

    flash[:alert] = "You don't have permission"
    redirect_back fallback_location: root_path
  end
end
