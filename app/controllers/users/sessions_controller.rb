# frozen_string_literal: true

module Users
  # Replacement of default Devise Sessions controller
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?

      redirect_path = if params[:current_word]
                        searches_show_path(search: { phrase: params[:current_word], part_of_speech: params[:current_pos] })
                      else
                        after_sign_in_path_for(resource)
                      end
      redirect_to redirect_path
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
