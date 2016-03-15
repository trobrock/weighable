require 'weighable/inflections'

class String
  Weighable::Weight::UNIT.each do |unit, _|
    unit = unit.to_s
    plural_unit = ActiveSupport::Inflector.pluralize(unit)
    define_method unit do
      Weighable::Weight.new(self, unit)
    end
    alias_method plural_unit, unit unless plural_unit == unit
  end
end
