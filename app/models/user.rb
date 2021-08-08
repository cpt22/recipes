class User < ApplicationRecord

  # Include default devise modules
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :trackable

  enum access_level: {admin: 100, user: 50, no_access: 0}

  validates :name, :email, :password, presence: true

  def admin_access?
    return self.admin?
  end

  def standard_access?
    return User.access_levels[access_level] >= User.access_levels[:user]
  end
end
