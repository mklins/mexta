# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :find_category, only: %i[edit update destroy]

  def index
    @categories = current_user.categories
  end

  def new
    @category = current_user.categories.build
  end

  def edit; end

  def create
    @category = current_user.categories.build(category_params)

    respond_to do |format|
      if @category.save
        flash.now[:success] = "Category successfully created!"
        format.turbo_stream
      else
        flash.now[:alert] = "Something went wrong"
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        flash.now[:success] = "Category successfully updated!"
        format.turbo_stream
      else
        flash.now[:alert] = "Something went wrong"
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      flash.now[:notice] = "Category destroyed!"
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
