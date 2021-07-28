class CategoryPolicy < ApplicationPolicy
  def index?
    return user.admin_access?
  end

  def create?
    return user.admin_access?
  end

  def new?
    return create?
  end

  def update?
    return user.admin_access?
  end

  def edit?
    return update?
  end

  def destroy?
    return user.admin_access?
  end

  def permitted_attributes
    return [:id, :name, :description]
  end
end
