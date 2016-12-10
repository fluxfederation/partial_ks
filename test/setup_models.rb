class User < ActiveRecord::Base
end

class BlogPost < ActiveRecord::Base
  belongs_to :user
end

class Tag < ActiveRecord::Base
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
