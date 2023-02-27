# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :home

  def after_sign_in_path_for(_resource)
    spendings_path
  end

  def after_sign_up_path_for(_resource)
    spendings_path
  end
end
