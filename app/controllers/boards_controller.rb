class BoardsController < ApplicationController
  skip_before_action :require_login, only: %i[new index]

  def index
    @boards = Board.all
  end

  def show
    @board = Board.find(params[:id])
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
        redirect_to boards_path, success: '入力完了！'
      else
        flash.now[:danger] = '入力できませんでした'
        render :new, status: :unprocessable_entity
      end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def create_params
    params.require(:board).permit(:place_name, :start_duration, :end_duration, :body, :budget)
  end
end
