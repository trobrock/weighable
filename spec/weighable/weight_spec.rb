require 'spec_helper'

module Weighable
  describe Weight do
    it 'should know all of the units' do
      expect(Weight::UNIT).to eq(gram: 0, ounce: 1, pound: 2, milligram: 3, kilogram: 4, each: 5)
    end

    context 'math' do
      let(:weight_each) { Weight.new(1, :each) }
      let(:weight_gram) { Weight.new(1.2, :gram) }
      let(:weight_ounce) { Weight.new(1, :ounce) }

      context 'adding' do
        it 'two like weights' do
          expect(weight_gram + weight_gram).to eq(Weight.new(2.4, :gram))
        end

        it 'two unlike weights' do
          expect(weight_gram + weight_ounce).to eq(Weight.new(BigDecimal.new('29.54952'), :gram))
        end

        it 'two unlike unit types' do
          expect { weight_each + weight_gram }.to raise_error(NoConversionError)
          expect { weight_gram + weight_each }.to raise_error(NoConversionError)
        end
      end

      context 'subtracting' do
        it 'two like weights' do
          expect(weight_gram - weight_gram).to eq(Weight.new(0, :gram))
        end

        it 'two unlike weights' do
          expect(weight_gram - weight_ounce).to eq(Weight.new(BigDecimal.new('-27.14952'), :gram))
        end

        it 'two unlike unit types' do
          expect { weight_each - weight_gram }.to raise_error(NoConversionError)
          expect { weight_gram - weight_each }.to raise_error(NoConversionError)
        end
      end

      context 'multiplying' do
        it 'two like weights' do
          expect(weight_gram * weight_gram).to eq(Weight.new(1.44, :gram))
        end

        it 'two unlike weights' do
          expect(weight_gram * weight_ounce).to eq(Weight.new(BigDecimal.new('34.019424'), :gram))
        end

        it 'two unlike unit types' do
          expect { weight_each * weight_gram }.to raise_error(NoConversionError)
          expect { weight_gram * weight_each }.to raise_error(NoConversionError)
        end
      end

      context 'dividing' do
        it 'two like weights' do
          expect(weight_gram / weight_gram).to eq(Weight.new(1, :gram))
        end

        it 'two unlike weights' do
          expect((weight_gram / weight_ounce).round(9))
            .to eq(Weight.new(BigDecimal.new('0.042328759'), :gram))
        end

        it 'two unlike unit types' do
          expect { weight_each / weight_gram }.to raise_error(NoConversionError)
          expect { weight_gram / weight_each }.to raise_error(NoConversionError)
        end
      end
    end

    context 'round' do
      let(:weight) { Weight.new(BigDecimal.new('60') / BigDecimal.new('34'), :gram) }

      it 'rounds the value to specified precision' do
        expect(weight.round(8)).to eq(Weight.new(BigDecimal.new('1.76470588'), :gram))
      end

      it 'rounds the value to default precision' do
        expect(weight.round).to eq(Weight.new(BigDecimal.new('2'), :gram))
      end
    end

    context 'from gram' do
      let(:weight) { Weight.new(1, :gram) }

      it 'converts to gram' do
        gram = BigDecimal.new('1')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal.new('1'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal.new('1') / BigDecimal.new('28.34952')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal.new('0.035273966'))
      end

      it 'converts to pound' do
        pound = BigDecimal.new('1') / BigDecimal.new('453.59237')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal.new('0.002204623'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal.new('1') * BigDecimal.new('1000')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal.new('1000'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal.new('1') / BigDecimal.new('1000')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal.new('0.001'))
      end

      it 'does not convert to each' do
        expect { weight.to(:each) }.to raise_error(NoConversionError)
      end
    end

    context 'from ounce' do
      let(:weight) { Weight.new(1, :ounce) }

      it 'converts to gram' do
        gram = BigDecimal.new('1') * BigDecimal.new('28.34952')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal.new('28.34952'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal.new('1')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal.new('1'))
      end

      it 'converts to pound' do
        pound = BigDecimal.new('1') / BigDecimal.new('16')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal.new('0.0625'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal.new('1') * BigDecimal.new('28349.52')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal.new('28349.52'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal.new('1') * BigDecimal.new('0.02834952')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal.new('0.02834952'))
      end

      it 'does not convert to each' do
        expect { weight.to(:each) }.to raise_error(NoConversionError)
      end
    end

    context 'from pound' do
      let(:weight) { Weight.new(1, :pound) }

      it 'converts to gram' do
        gram = BigDecimal.new('1') * BigDecimal.new('453.59237')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal.new('453.59237'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal.new('1') * BigDecimal.new('16')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal.new('16'))
      end

      it 'converts to pound' do
        pound = BigDecimal.new('1')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal.new('1'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal.new('1') * BigDecimal.new('453592.37')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal.new('453592.37'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal.new('1') * BigDecimal.new('0.45359237')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal.new('0.45359237'))
      end

      it 'does not convert to each' do
        expect { weight.to(:each) }.to raise_error(NoConversionError)
      end
    end

    context 'from milligram' do
      let(:weight) { Weight.new(1, :milligram) }

      it 'converts to gram' do
        gram = BigDecimal.new('1') / BigDecimal.new('1000')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal.new('0.001'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal.new('1') / BigDecimal.new('28349.52')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal.new('0.000035274'))
      end

      it 'converts to pound' do
        pound = BigDecimal.new('1') / BigDecimal.new('453592.37')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal.new('0.000002205'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal.new('1')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal.new('1'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal.new('1') / BigDecimal.new('1000000')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal.new('0.000001'))
      end

      it 'does not convert to each' do
        expect { weight.to(:each) }.to raise_error(NoConversionError)
      end
    end

    context 'from kilogram' do
      let(:weight) { Weight.new(1, :kilogram) }

      it 'converts to gram' do
        gram = BigDecimal.new('1') * BigDecimal.new('1000')
        expect(weight.to(:gram)).to eq(Weight.new(gram, :gram))
        expect(weight.to_gram).to eq(Weight.new(gram, :gram))
        expect(weight.to(:gram).value.round(9)).to eq(BigDecimal.new('1000'))
      end

      it 'converts to ounce' do
        ounce = BigDecimal.new('1') / BigDecimal.new('0.02834952')
        expect(weight.to(:ounce)).to eq(Weight.new(ounce, :ounce))
        expect(weight.to_ounce).to eq(Weight.new(ounce, :ounce))
        expect(weight.to(:ounce).value.round(9)).to eq(BigDecimal.new('35.273965838'))
      end

      it 'converts to pound' do
        pound = BigDecimal.new('1') / BigDecimal.new('0.45359237')
        expect(weight.to(:pound)).to eq(Weight.new(pound, :pound))
        expect(weight.to_pound).to eq(Weight.new(pound, :pound))
        expect(weight.to(:pound).value.round(9)).to eq(BigDecimal.new('2.204622622'))
      end

      it 'converts to milligram' do
        milligram = BigDecimal.new('1') * BigDecimal.new('1000000')
        expect(weight.to(:milligram)).to eq(Weight.new(milligram, :milligram))
        expect(weight.to_milligram).to eq(Weight.new(milligram, :milligram))
        expect(weight.to(:milligram).value.round(9)).to eq(BigDecimal.new('1000000'))
      end

      it 'converts to kilogram' do
        kilogram = BigDecimal.new('1')
        expect(weight.to(:kilogram)).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to_kilogram).to eq(Weight.new(kilogram, :kilogram))
        expect(weight.to(:kilogram).value.round(9)).to eq(BigDecimal.new('1'))
      end

      it 'does not convert to each' do
        expect { weight.to(:each) }.to raise_error(NoConversionError)
      end
    end

    context 'from each' do
      let(:weight) { Weight.new(1, :each) }

      it 'does not convert to gram' do
        expect { weight.to(:gram) }.to raise_error(NoConversionError)
      end

      it 'does not convert to ounce' do
        expect { weight.to(:ounce) }.to raise_error(NoConversionError)
      end

      it 'does not convert to pound' do
        expect { weight.to(:pound) }.to raise_error(NoConversionError)
      end

      it 'does not convert to milligram' do
        expect { weight.to(:milligram) }.to raise_error(NoConversionError)
      end

      it 'does not convert to kilogram' do
        expect { weight.to(:kilogram) }.to raise_error(NoConversionError)
      end

      it 'converts to each' do
        each = BigDecimal.new('1')
        expect(weight.to(:each)).to eq(Weight.new(each, :each))
        expect(weight.to_each).to eq(Weight.new(each, :each))
        expect(weight.to(:each).value.round(9)).to eq(BigDecimal.new('1'))
      end
    end
  end
end
