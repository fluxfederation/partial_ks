# PartialKs

A library to sync a subset of your database

# Usage

So how does it work ?


```
PartialKs::Sync.new(manual_configuration).run! do |tables_to_filter, tables|
  puts tables_to_filter.inspect
  puts tables.inspect
end
```

You can specify manual configurations if needed.

```
manual_configuration = [
  [User, nil, -> { User.where(:id => [1]) }],     # specify a subset of users. as users have no parent, specify `nil`
  [BlogPost, User]                         # filter blog_posts by User
]
```

# Public API

It currently consists of :

  - PartialKs::Sync


# Not supported

Things that are not supported in this version.

* Polymorphic relationships
* Tables with STI


