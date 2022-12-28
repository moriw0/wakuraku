class RetirementsController < ApplicationController
  def new
  end

  def create
    if current_user.retire_process_and_discard
      reset_session
      redirect_to root_path, notice: t(:notice_retirement_create)
    else
      flash.now[:error] = '退会することができませんでした'
      render :new
    end
  end
end
