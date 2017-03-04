This document should tell all you need to know for contributing to this project.

# Testing

Tested with activerecord 4.2.7.1, 4.2.8 and 5.0.1 (on Ruby 2.2.3)


To install and run tests :

```
rm Gemfile.lock
ACTIVERECORD_VERSION="~> 4.2.8" bundle
bundle exec rake
```

# Design

Partial KS is meant to run on *two* databases : the source DB and the target DB.

The building of the filter is done on the target DB.
  - Hence, instructions for a table *cannot* be run until all data for its parent
    table is fully downloaded onto the target DB.

Filters are run on the source DB.
  - Note that a SQL statement from the target DB will behave differently on the source DB.
