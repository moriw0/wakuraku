class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from Exception, with: :error_500 unless Rails.env.development?
  unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error_404
  end

  private

  def error_500(err)
    logger.error [err, *err.backtrace].join("\n")
    render 'error_500', status: :internal_server_error, formats: [:html]
  end

  def error_404(_err)
    render 'error_404', status: :not_found, formats: [:html]
  end
end
