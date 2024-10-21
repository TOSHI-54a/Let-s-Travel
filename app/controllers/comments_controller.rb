class CommentsController < ApplicationController
    def create
      comment = current_user.comments.build(comment_params)
      if comment.save
        redirect_to boards_path(comment.board), success: 'コメント投稿成功'
      else
        @board = Board.find(params[:board_id])
        @comment = comment
        @comments = @board.comments.includes(:user).order(created_at: :desc)
        render 'boards/show', danger: 'コメント失敗'
      end
    end

    def edit
      @comment = Comment.find(params[:id])
    end

    def update
      @comment = Comment.find(params[:id])
      board = @comment.board
      if @comment.update(update_comment)
        redirect_to board_path(board), flash: {success: '成功'}
      else
        flash.now[:danger] = '失敗'
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @comment = current_user.comments.find(params[:id])
      @comment.destroy!
    end

    private
  
    def comment_params
      params.require(:comment).permit(:body).merge(board_id: params[:board_id])
    end

    def update_comment
      params.require(:comment).permit(:body)
    end
  end