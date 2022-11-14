class UsersController < ApplicationController
  def show(id:)
    @user = User.find(id)
    @events = @user.created_events
  end
end
