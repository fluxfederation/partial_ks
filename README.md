# PartialKs

A library to sync a subset of your database

## Usage

See the following example:

```
configuration = [
  [User, nil, -> { User.where(:id => [1]) }],     # specify a subset of users. as users have no "parent", specify `nil`
  [BlogPost, User]                                # filter blog_posts by User
]

PartialKs::Sync.new(configuration).run! do |tables_to_filter, tables|
  puts tables_to_filter.inspect
  puts tables.inspect
end
```

## So how does it work ?

The idea is that PartialKS builds a tree of models and uses
the parent of a model to sync a subset of the database records for
the model. E.g. 

```
  User id 1, 3, 5, 7
  User -> BlogPost
```

PartialKS will only download blog_posts records for users 1, 3, 5, and 7.

Most of the time PartialKS will be able to deduce the parent automatically.

If a model has no "parent", PartialKS will download the whole table.

If a model has "multiple parents", then PartialKS will not choose, and hence
will download the whole table. If it is not a problem to download the whole
table, then you can address the warning at your leisure.

## Public API

It currently consists of :

  - PartialKs::Sync

## Not supported

Things that are not supported in this version.

* Polymorphic relationships
* Tables with STI
