PartialKs
  - ConfigurationGenerator
  - Runner
    - runs
    - reports (mostly for debugging)

So how does it work ?

`brew install kitchen-sync`

```
config = PartialKs::ConfigurationGenerator.new(manual_configuration).call
PartialKs::Runner.new([config]).run!
```

TODO :

Rename PartialKs::ConfigurationGenerator#call to something better
Minimize Public API
Get license approval (MIT)


