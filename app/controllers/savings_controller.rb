class SavingsController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def new
  end

  def create
    @saving = current_user.savings.new(saving_params)
    if @saving.save
      redirect_to savings_path, flash: { success: '節約成功！' }
    else
      flash.now[:danger] = '節約金額の登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @saving = Saving.new
    @savings = current_user.savings.includes(:user).order(created_at: :desc)
    @total_savings = @savings.sum(:value)
  end

  def show
  end

  def edit
    @saving = Saving.find(params[:id])
  end

  def update
    @saving = Saving.find(params[:id])
    if @saving.update(update_saving)
      redirect_to savings_path, flash: { success: '成功' }
    else
      flash.now[:danger] = '失敗'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def saving_params
    params.require(:saving).permit(:value)
  end

  def update_saving
    params.require(:saving).permit(:value)
  end

end