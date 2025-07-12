class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Problem, unlock_time: ..Time.current
    can :create, User, [ :email, :username, :password_digest, :password, :password_confirmation ]

    return unless user.present?
    # Logged in users can:
    can [ :create ], Answer, user: user
    can :read, User, [ :email, :username ], id: user.id

    return unless user.admin?
    can :manage, :all
  end
end
