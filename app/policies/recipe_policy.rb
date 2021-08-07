class RecipePolicy < ApplicationPolicy
  def index?
    return true
  end

  def show?
    return true
  end

  def create?
    return user.standard_access?
  end

  def new?
    return create?
  end

  def update?
    return (user == record.user) || user.admin_access?
  end

  def edit?
    return update?
  end

  def destroy?
    return (user == record.user) || user.admin_access?
  end

  def permitted_attributes
    return [:name, :description, :creator, :content, :main_image,
      {recipe_ingredients_attributes: [:id, :ingredient_name, :quantity, :unit, :_destroy]}]
  end
end
