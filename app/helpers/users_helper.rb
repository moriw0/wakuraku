module UsersHelper
  def current_user?(user)
    return false unless current_user

    user.id == current_user.id
  end

  def avatar(user)
    if user.avatar.attached?
      user.avatar
    else
      asset_pack_path 'media/images/blank_user_image.png'
    end
  end
end
