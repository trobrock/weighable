module Weighable
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def weighable(column, presence: false)
        if presence
          validates "#{column}_value", presence: presence
          validates "#{column}_unit", presence: presence
        else
          validates "#{column}_value", presence: presence, if: "#{column}_unit.present?"
          validates "#{column}_unit", presence: presence, if: "#{column}_value.present?"
        end

        validates "#{column}_unit", inclusion: {
          in: Weight::UNIT.values,
          message: 'is not a valid unit',
          allow_nil: true
        }

        define_method "#{column}=" do |weight|
          public_send("#{column}_value=", weight.try(:value))
          public_send("#{column}_unit=", weight.try(:unit))
        end

        define_method column do
          Weight.new(weight_value, weight_unit) if weight_value.present? && weight_unit.present?
        end
      end
    end
  end
end
