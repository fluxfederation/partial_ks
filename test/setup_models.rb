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
