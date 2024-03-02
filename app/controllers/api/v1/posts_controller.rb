module Api
  module V1
    class PostsController < ApplicationController
      # before_action :authenticate_user!, only: [:create, :update, :destroy]
      before_action :set_post, only: [:show, :update, :destroy, :like, :unlike]
    
      # GET /posts
      def index
        @posts = Post.all.order(created_at: :desc)

        render json: @posts
      end

      # GET /posts/1
      def show
        @post = Post.find(params[:id])
        render json: @post
      end
    
      # POST /posts
      def create
        @post = Post.new(post_params)
        @post.user = User.first

        puts "👨🏻‍💻👨🏻‍💻👨🏻‍💻👨🏻‍💻 Creating... 👨🏻‍💻👨🏻‍💻👨🏻‍💻👨🏻‍💻👨🏻‍💻"
        user = User.find_by(id: @post.user_id)

        if @post.save
          User.first.create_notification(
            {
              message: "#{user.username} created a new post",
              user_id: @post.user_id,
              post_id: @post.id
            }
          )
          render json: @post, status: :created
        else
          render_error(@post, :unprocessable_entity, "Post not created")
        end
      end
    
      # PATCH/PUT /posts/1
      def update
        if @post.update(post_params)
          render json: @post
        else
          render_error(@post, :unprocessable_entity)
        end
      end

      def already_liked?(post)
        post.likes.where(user_id: User.first.id).exists?
      end

      # POST /posts/1/like
      def like
        if already_liked?(@post)
          render json: {
            message: "You already liked this post"
          }, status: :bad_request
        else
          @like = @post.likes.new(user_id: User.first.id)
          if @like.save
            User.first.create_notification({
              message: "#{User.first.username} liked your post",
              user_id: @post.user_id,
              post_id: @post.id
            })
            render json: {
              message: "❤️"
            }, status: :created
          else
            render_error(@like, :unprocessable_entity)
          end
        end
      end

      # POST /posts/1/unlike
      def unlike
        if !already_liked?(@post)
          render json: {
            message: "You haven't liked this post yet"
          }, status: :bad_request
        else
          @like = @post.likes.where(user_id: User.first.id).first
          if @like.destroy
            render json: {
              message: "💔"
            }, status: :ok
          else
            render_error(@like, :unprocessable_entity)
          end
        end
      end
    
      # DELETE /posts/1
      def destroy
        # Only the post owner can delete the post
        # if @post.user_id == User.first.id
        #   @post.destroy
        #   render json: {
        #     message: "Post deleted"
        #   }, status: :ok
        # else
        #   render json: {
        #     message: "You can't delete this post"
        #   }, status: :bad_request
        # end

        @post.destroy
        render json: {
          message: "Post deleted"
        }, status: :ok
      end
    
      private
        def set_post
          @post = Post.find(params[:id])
        end
    
        def post_params
          params.permit(:caption, :image, :user_id, :is_video, :size)
        end

        # Render error message
        def render_error(object, status)
          render json: {
            errors: object.errors.full_messages
          }, status: status
        end
    end
  end
end    

