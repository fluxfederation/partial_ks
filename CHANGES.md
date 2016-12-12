# Changelog

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
