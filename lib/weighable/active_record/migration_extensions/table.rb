module Weighable
  module ActiveRecord
    module MigrationExtensions
      module Table
        def weighable(column)
          column "#{column}_value", :decimal, precision: 30, scale: 15
          column "#{column}_unit", :integer, limit: 1
          column "#{column}_display_unit", :integer, limit: 1
        end

        def remove_weighable(column)
          remove_column "#{column}_value"
          remove_column "#{column}_unit"
          remove_column "#{column}_display_unit"
        end
      end
    end
  end
end
