class IngredientPolicy < ApplicationPolicy
  def index?
    return admin_access?
  end

  def create?
    return standard_access?
  end

  def new?
    return create?
  end

  def update?
    return admin_access?
  end

  def edit?
    return update?
  end

  def destroy?
    return admin_access?
  end

  def permitted_attributes
    return [:id, :name]
  end
end
