# frozen_string_literal: true

RSpec.describe SheetsV4::Color do
  describe '.respond_to?' do
    it 'should respond to all the SheetsV4::COLORS names' do
      SheetsV4::COLORS.each_key do |color_name|
        expect { described_class.respond_to?(color_name) }.not_to raise_error
      end
    end
  end

  describe '.method_missing' do
    it 'should implement methods for all the SheetsV4::COLORS names' do
      SheetsV4::COLORS.each_key do |color_name|
        expect(described_class.send(color_name)).to eq(SheetsV4::COLORS[color_name])
      end
    end
  end
end
