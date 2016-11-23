ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.string :email
    t.timestamps null: false
  end

  create_table :blog_posts, :force => true do |t|
    t.string :title
    t.references :user, null: false
    t.timestamps null: false
  end

  create_table :tags, :force => true do |t|
    t.string :name
    t.timestamps null: false
  end

  create_table :post_tags, :force => true do |t|
    t.references :blog_post, null: false
    t.references :tag, null: false
    t.timestamps null: false
  end
end
