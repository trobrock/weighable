module Weighable
  class Railtie < ::Rails::Railtie
    initializer 'weighable.initialize' do
      ActiveSupport.on_load(:active_record) do
        require 'weighable/model'
        require 'weighable/active_record/migration_extensions/schema_statements'
        require 'weighable/active_record/migration_extensions/table'
        require 'weighable/core_ext'
        ::ActiveRecord::Migration
          .__send__(:include, Weighable::ActiveRecord::MigrationExtensions::SchemaStatements)
        ::ActiveRecord::ConnectionAdapters::TableDefinition
          .__send__(:include, Weighable::ActiveRecord::MigrationExtensions::Table)
        ::ActiveRecord::ConnectionAdapters::Table
          .__send__(:include, Weighable::ActiveRecord::MigrationExtensions::Table)
      end
    end
  end
end
