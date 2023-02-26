# frozen_string_literal: true

class SpendingsController < ApplicationController
  before_action :find_spending, only: %i[edit update destroy]

  def index
    @spendings = current_user.spendings.order(created_at: :desc)
  end

  def new
    @spending = current_user.spendings.build
  end

  def edit; end

  def create
    @spending = current_user.spendings.build(spending_params)

    respond_to do |format|
      if @spending.save
        flash.now[:success] = "Spending successfully created!"
        format.turbo_stream
      else
        flash.now[:alert] = "Something went wrong"
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @spending.update(spending_params)
        flash.now[:success] = "Spending successfully updated!"
        format.turbo_stream
      else
        flash.now[:alert] = "Something went wrong"
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @spending.destroy

    respond_to do |format|
      flash.now[:notice] = "Spending destroyed!"
      format.html { redirect_to spendings_path, status: :see_other }
      format.turbo_stream
    end
  end

  private

  def spending_params
    params.require(:spending).permit(:title, :amount, :description, :category_id)
  end

  def find_spending
    @spending = current_user.spendings.find(params[:id])
  end
end
