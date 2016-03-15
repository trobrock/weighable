module Weighable
  module ActiveRecord
    module MigrationExtensions
      module SchemaStatements
        def add_weighable(table_name, column)
          add_column table_name, "#{column}_value", :decimal, precision: 30, scale: 15
          add_column table_name, "#{column}_unit", :integer, limit: 1
        end

        def remove_weighable(table_name, column)
          remove_column table_name, "#{column}_value"
          remove_column table_name, "#{column}_unit"
        end
      end
    end
  end
end
