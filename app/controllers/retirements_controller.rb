class RetirementsController < ApplicationController
  def new
  end

  def create
    if current_user.destroy
      reset_session
      redirect_to root_path, notice: '退会完了しました'
    else
      flash.now[:error] = '退会することができませんでした'
      render :new
    end
  end
end
