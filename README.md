# PartialKs

A library to use kitchen-sync to sync a subset of your database

# Usage

So how does it work ?


```
manual_configuration = []
config = PartialKs::ConfigurationGenerator.new(manual_configuration).call
PartialKs::Runner.new([config]).run! do |tables_to_filter, tables|
  puts tables_to_filter.inspect
  puts tables.inspect
end
```

You can specify manual configurations if needed.

```
manual_configuration = [
  [User, nil, User.where(:id => [1])],     # specify a subset of users. as users have no parent, specify `nil`
  [BlogPost, User]                         # filter blog_posts by User
]
```

NB: The first use case for this gem is to be run in conjuction with [Kitchen Sync](https://github.com/willbryant/kitchen_sync). On OSX, one can install Kitchen Sync using `brew install kitchen-sync`

*TODO*

* Provide a way for users to pass in manual configurations
* Tool to run report using bundle exec

# Public API

It currently consists of :

  - ConfigurationGenerator
  - Runner
    - runs
    - reports (mostly for debugging)

*TODO*

* Rename PartialKs::ConfigurationGenerator#call to something better
* Minimize Public API

# Not supported

Things that are not supported in this version.

* Polymorphic relationships
* Tables with STI


