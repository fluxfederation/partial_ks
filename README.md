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
  ["users", nil, User.where(:id => [1])],      # specify a subset of users. as users have no parent, specify `nil`
  ["blog_posts", User]                         # filter blog_posts by User
]
```

TODO :

* Rename PartialKs::ConfigurationGenerator#call to something better
* What in the world is the tuples in `manual_configuration` meant to be ?
* Minimize Public API


