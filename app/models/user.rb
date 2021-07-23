class User < ApplicationRecord

  # Include default devise modules
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :trackable

  enum access_level: {admin: 100, user: 50, no_access: 0}

  def admin_access?
    return self.admin?
  end

  def standard_access?
    return self.user? || self.admin?
  end
end