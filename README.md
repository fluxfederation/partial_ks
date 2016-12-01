PartialKs
  - ConfigurationGenerator
  - Runner
    - runs
    - reports (mostly for debugging)

So how does it work ?

`brew install kitchen-sync`

```
manual_configuration = []
config = PartialKs::ConfigurationGenerator.new(manual_configuration).call
PartialKs::Runner.new([config]).run!
```

You can specify manual configurations if needed.

```
manual_configuration = [
  [User, nil, User.where(:id => [1])],     # specify a subset of users. as users have no parent, specify `nil`
  [BlogPost, User]                         # filter blog_posts by User
]
```

TODO :

* Rename PartialKs::ConfigurationGenerator#call to something better
* Minimize Public API
* Tool to run report using bundle exec

# Not supported

Things that are not supported in this version.

* Polymorphic relationships
* Tables with STI


