module UsersHelper
  def current_user?(user)
    return false unless current_user

    user.id == current_user.id
  end
end
