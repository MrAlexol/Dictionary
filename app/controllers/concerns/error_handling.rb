# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :notfound
    rescue_from ActionController::UnknownFormat, with: :raise_not_found

    def notfound(exception)
      logger.warn exception
      render_404_page
    end

    def not_found_no_logs
      # Будем отправлять подготовленную страничку с объяснением ошибки
      render_404_page
      # Либо можно просто игнорировать хакера
      # head :no_content, status: 404, layout: false
    end

    private

    def render_404_page
      if I18n.locale == :ru
        render file: 'public/404ru.html', status: :not_found, layout: false
      else
        render file: 'public/404.html', status: :not_found, layout: false
      end
    end
  end
end
