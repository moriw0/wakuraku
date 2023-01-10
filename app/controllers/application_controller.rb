class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from Exception, with: :error500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error404 unless Rails.env.development?

  private

  def error500(e)
    logger.error [e, *e.backtrace].join("\n")
    render 'error500', status: 500, formats: [:html]
  end

  def error404(e)
    render 'error404', status: 404, formats: [:html]
  end
end
