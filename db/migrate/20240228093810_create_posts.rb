class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.text :caption
      t.string :image, null: false
      t.integer :likes_count, default: 0
      t.integer :comments_count, default: 0
      t.boolean :is_video, default: false
      t.string :size, default: "1080x1080"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
