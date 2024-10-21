class BoardsController < ApplicationController
  skip_before_action :require_login, only: %i[show index]
  before_action :set_board, only: %i[show edit update destroy]

  def index
    @boards = Board.all
  end

  def show
    @comment = Comment.new
    @comments = @board.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(create_params)
    @board.user_id = current_user.id
      if @board.save
        redirect_to boards_path, success: '投稿完了！'
      else
        flash.now[:danger] = '投稿できませんでした'
        render :new, status: :unprocessable_entity
      end
  end

  def edit; end

  def update
    if @board.update(edit_params)
      redirect_to board_path, flash: { success: '更新しました'}
    else
      flash.now[:danger]= '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @board.destroy!
      redirect_to boards_path, success: '削除成功！'
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:board).permit(:place_name, :start_duration, :end_duration, :body, :budget)
  end

  def edit_params
    params.require(:board).permit(:place_name, :start_duration, :end_duration, :budget, :body)
  end

  def set_board
    @board = Board.find(params[:id])
  end
end
