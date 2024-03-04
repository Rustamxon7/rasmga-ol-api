class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :username, :bio, :created_at, :updated_at, :avatar, :posts_count, :followers_count, :followees_count, :is_followed

  DEFAULT_AVATAR = 'https://placehold.co/600x600/EEE/31343C'

  def avatar
    if object.avatar.present?
      object.avatar.url
    else
      DEFAULT_AVATAR
    end
  end

  def posts_count
    object.posts.count
  end

  def followers_count
    object.followers.count
  end

  def followees_count
    object.followees.count
  end

  def is_followed
    current_user.followees.include?(object)
  end
end
