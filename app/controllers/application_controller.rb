# frozen_string_literal: true

# App controller. Handles errors and manages localization
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :switch_locale
  include ErrorHandling

  def switch_locale(&action)
    locale = current_user[:locale] if current_user
    params_locale = params[:locale] if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
    locale ||= params_locale || locale_from_header || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def locale_from_header
    request.env.fetch('HTTP_ACCEPT_LANGUAGE', '').scan(/[a-z]{2}/).first
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:locale])
    devise_parameter_sanitizer.permit(:account_update, keys: [:locale])
  end
end
