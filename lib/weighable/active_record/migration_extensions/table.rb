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
          remove "#{column}_value"
          remove "#{column}_unit"
          remove "#{column}_display_unit"
        end
      end
    end
  end
end
