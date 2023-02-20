# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :find_category, only: %i[edit update destroy]

  def index
    @categories = current_user.categories
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = current_user.categories.build(category_params)

    respond_to do |format|
      if @category.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_path, status: :see_other }
      format.turbo_stream
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = current_user.categories.find(params[:id])
  end
end
