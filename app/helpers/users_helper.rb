module UsersHelper
  def current_user?
    @user.id == current_user.id
  end
end
