module Weighable
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def weighable(column, presence: false, store_as: nil)
        apply_validations(column, presence: presence, store_as: store_as)

        define_method "#{column}=" do |weight|
          original_unit = weight.try(:unit)
          weight = weight.try(:to, store_as) if store_as

          public_send("#{column}_value=", weight.try(:value))
          public_send("#{column}_unit=", weight.try(:unit))
          public_send("#{column}_display_unit=", original_unit)
        end

        define_method column do
          value        = public_send("#{column}_value")
          unit         = public_send("#{column}_unit")
          display_unit = public_send("#{column}_display_unit")
          return unless value.present? && unit.present?
          weight = Weight.new(value, unit)
          weight = weight.to(display_unit) if store_as
          weight
        end
      end

      private

      def apply_validations(column, presence: false, store_as: nil)
        if presence
          validates "#{column}_value", presence: presence
          validates "#{column}_unit", presence: presence
          validates "#{column}_display_unit", presence: presence if store_as
        else
          validates "#{column}_value", presence: presence, if: "should_validate_#{column}?"
          validates "#{column}_unit", presence: presence, if: "should_validate_#{column}?"
          if store_as
            validates "#{column}_display_unit", presence: presence, if: "should_validate_#{column}?"
          end
        end

        validates "#{column}_unit", inclusion: {
          in: Weight::UNIT.values,
          message: 'is not a valid unit',
          allow_nil: true
        }

        define_method "should_validate_#{column}?" do
          public_send("#{column}_value").present? ||
            public_send("#{column}_unit").present? ||
            public_send("#{column}_display_unit").present?
        end
      end
    end
  end
end
