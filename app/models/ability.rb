# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    cannot :manage, :all

    if user.has_role?(:guest)
      can :manage, :all

    elsif user.has_role?(:admin)
      can :manage, :all

    else
      can :read, :all
    end
  end
end
