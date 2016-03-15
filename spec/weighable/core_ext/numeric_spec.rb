require 'spec_helper'
require 'weighable/core_ext/numeric'

describe Numeric do
  it 'creates helper methods for all units' do
    expect(2.each).to eq(Weighable::Weight.new(2, :each))
    expect(2.grams).to eq(Weighable::Weight.new(2, :gram))
    expect(2.gram).to eq(Weighable::Weight.new(2, :gram))
    expect(2.ounces).to eq(Weighable::Weight.new(2, :ounce))
    expect(2.ounce).to eq(Weighable::Weight.new(2, :ounce))
    expect(2.pounds).to eq(Weighable::Weight.new(2, :pound))
    expect(2.pound).to eq(Weighable::Weight.new(2, :pound))
    expect(2.milligrams).to eq(Weighable::Weight.new(2, :milligram))
    expect(2.milligram).to eq(Weighable::Weight.new(2, :milligram))
    expect(2.kilograms).to eq(Weighable::Weight.new(2, :kilogram))
    expect(2.kilogram).to eq(Weighable::Weight.new(2, :kilogram))
  end
end
