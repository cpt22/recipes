class IngredientPolicy < ApplicationPolicy
  def index?
    return user.admin_access?
  end

  def create?
    return user.standard_access?
  end

  def new?
    return user.standard_access?
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
    return [:id, :name]
  end
end
