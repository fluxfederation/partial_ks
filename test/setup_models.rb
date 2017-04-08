class User < ActiveRecord::Base
  has_many :blog_posts
end

class BlogPost < ActiveRecord::Base
  belongs_to :user
  has_many :post_tags
end

class Tag < ActiveRecord::Base
  has_many :post_tags
end

class PostTag < ActiveRecord::Base
  belongs_to :blog_post
  belongs_to :tag
end

class OldEntry < ActiveRecord::Base
  self.table_name = "cms_table"
end

class OldTag < ActiveRecord::Base
  belongs_to :old_entry, :foreign_key => 'blog_post_id'
end

class NewModel < ActiveRecord::Base
  # no tables, e.g. migration not run yet
  belongs_to :user
end
