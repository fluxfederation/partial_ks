# Changelog

# 0.7.0

* Removed Kitchen Sync specific behaviour - now yields full SQL statements (and no longer kitchen sync specific filter format)

To maintain previous behaviour, use the folllowing code snippet:

```
PartialKs::Sync.new(manual_configuration).run! do |tables_to_filter, tables|
  kitchen_sync_filter = {}
  tables_to_filter.each do |table_name, filter|
    kitchen_sync_filter[table_name] = { "only" => filter }
  end
end
```

* Rename main class to PartialKs::Sync

* Remove FilteredTable#where_fragment

* Introduces FilteredTable#to_sql

# 0.6.0

Propogate filters down the tree. If the parent downloads the whole table, do the same for the child.

# 0.5.0

* New single entry point, `PartialKs::KitchenSync`. This means that Runner and ConfigurationGenerator are now internal concerns

* Teach ModelsList about #issues - Basically a list of models where its "parent" is a MultiParent. Exposed via PartialKs::KitchenSync#issues

* Various refactors and simplifications

# 0.4.2

Fix an issue where we did not support the new ApplicationRecord convention

# 0.4.1

Fix issue where models which are missing their table would error out the whole process.

# 0.4.0

Allow lambdas to be used as a custom filter

# 0.3.0

No functionality changes but specify restrictions already observed in gemspec

# 0.2.0

* Support filtering via a has_many association

You can now skip manually specifying the resultant filter on a has_many "parent". So previously:

```
[
  [User, Tags, User.where(:id => Tags.pluck(:id))]
]
```

can now just be :

```
[
  [User, Tags]
]
```

* Can now specify a full SQL statement in the manual specification


# 0.1.1

Fix minor regression with Runner#report

# 0.1.0

* Switch to using Rails models rather than table names.

You must now specify rails models in your manual_configuration.

Remember, if you want to configure all models, you must eager load in development.

```
  Rails.application.eager_load!
  Rails::Engine.subclasses.map(&:eager_load!)
```

* Reject polymorphic relationships from ever being a candidate parent.

This has the implication that a table that wasn't considered top level could be
top level.

* Bugfix: Emit valid where SQL fragments for models which has a assocation with `:foreign_key`
that does not follow convention

## 0.0.6

Allow manual_configuration to transition to using model names (moving off from table names)

## 0.0.5

API change for `ConfigurationGenerator` - removes `ignored_table_names` option.
Replaced with `table_names` option.
