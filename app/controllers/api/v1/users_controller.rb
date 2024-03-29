module Api
  module V1
    class UsersController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      before_action :authenticate_user!, only: [:me, :show, :update, :follow, :unfollow, :following, :followers, :notifications]
      before_action :set_user, only: [:destroy, :follow, :unfollow, :followers, :following]
      before_action :set_user_by_username, only: [:show_by_username, :user_posts]

      def highlights
        @users = User.all.where.not(id: current_user.id).limit(12).order(created_at: :desc).map do |user|
          {
            username: user.username,
            avatar: user.avatar.url ? user.avatar.url : "https://ui-avatars.com/api/?name=#{user.username}&background=random"
          }
        end

        render json: @users, status: :ok
      end

      def notifications
        @notifications = current_user.notifications
        render json: @notifications, status: :ok
      end

      def me
        render json: current_user, serializer: UserSerializer, status: :ok
      end

      def show
        render json: @user, serializer: UserSerializer, status: :ok
      end

      def show_by_username
        if @user
          render json: @user, serializer: UserSerializer, status: :ok
        else
          render json: {
            message: "User not found"
          }, status: :not_found
        end
      end

      # Get /users/1/posts
      def user_posts
        @posts = @user.posts.order(created_at: :desc)
        render json: @posts, each_serializer: PostSerializer, status: :ok
      end

      def search
        @users = User.search(params[:username])
        render json: @users, each_serializer: UserSerializer, status: :ok
      end

      def update
        @user = current_user
        if @user.update(user_params)
          render json: @user, serializer: UserSerializer, status: :ok
        else
          render_error(@user, :unprocessable_entity)
        end
      end

      def already_followed?(user)
        current_user.followees.include?(user)
      end

      def follow
        if already_followed?(@user)
          render json: {
            message: "You are already following this user"
          }, status: :bad_request
        else
          current_user.followees << @user
          render json: @user, serializer: UserSerializer, status: :ok
        end
      end

      def unfollow
        if already_followed?(@user)
          current_user.followees.delete(@user)
          render json: @user, serializer: UserSerializer, status: :ok
        else
          render json: {
            message: "You are not following this user"
          }, status: :bad_request
        end
      end

      def following
        render json: @user.followees, each_serializer: FollowSerializer, status: :ok
      end

      def followers
        render json: @user.followers, each_serializer: FollowSerializer, status: :ok
      end

      private

      def set_user
        @user = User.find(params[:id]) || User.find_by(username: params[:username])
      end

      def set_user_by_username
        @user = User.find_by(username: params[:username])
      end

      def user_params
        params.permit(:id, :first_name, :last_name, :email, :avatar, :username, :bio)
      end

      def not_found
        render json: { error: 'Not Found' }, status: :not_found
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