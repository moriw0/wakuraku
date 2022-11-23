class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show(id:)
    @user = User.find(id)
    @events = @user.created_events
  end
end
