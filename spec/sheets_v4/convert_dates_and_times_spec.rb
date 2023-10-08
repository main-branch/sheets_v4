# Copyright (c) 2023 Yahoo
# frozen_string_literal: true

require 'yaml'

require 'date'
require 'active_support'
require 'active_support/core_ext/time'

RSpec.describe SheetsV4::ConvertDatesAndTimes do
  let(:converter) { described_class.new(time_zone_name) }
  let(:tolerance) { 0.00000001 }

  context 'with an invalid time zone' do
    let(:time_zone_name) { 'bogus time zone' }
    it 'should raise an error' do
      expect { converter }.to raise_error(RuntimeError)
    end
  end

  context 'when the spreadsheet has the America/Los_Angeles time zone' do
    let(:time_zone_name) { 'America/Los_Angeles' }
    # let(:time_zone) { ActiveSupport::TimeZone.new(time_zone_name) }

    it 'should not raise an error' do
      expect { converter }.not_to raise_error
    end

    describe '#datetime_to_gs' do
      subject { converter.datetime_to_gs(date_time) }
      context 'with nil' do
        let(:date_time) { nil }
        it 'should return an empty string' do
          expect(subject).to eq('')
        end
      end

      context 'with DateTime 2021-05-17 18:36:00 UTC' do
        let(:date_time) { DateTime.parse('2021-05-17 18:36:00 UTC') }
        let(:expected_value) { 44_333.48333333 }

        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'with DateTime 2021-05-17 11:36:00-0700' do
        let(:date_time) { DateTime.parse('2021-05-17 11:36:00-0700') }
        let(:expected_value) { 44_333.48333333 }

        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'with DateTime 2021-01-01 11:22:33 UTC' do
        let(:date_time) { DateTime.parse('2021-01-01 11:22:33 UTC') }
        let(:expected_value) { 44_197.14065972 }

        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end
    end

    describe '#date_to_gs' do
      subject { converter.date_to_gs(date) }

      context 'with nil' do
        let(:date) { nil }
        it 'should return an empty string' do
          expect(subject).to eq('')
        end
      end

      context 'with a Date 2021-05-18' do
        let(:date) { Date.parse('2021-05-18') }
        let(:expected_value) { 44_334.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-05-18 01:00:00 UTC' do
        let(:date) { DateTime.parse('2021-05-18 01:00:00 UTC') }
        let(:expected_value) { 44_333.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-05-18 23:00:00 UTC' do
        let(:date) { DateTime.parse('2021-05-18 23:00:00 UTC') }
        let(:expected_value) { 44_334.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-01-01 23:59:59-0800' do
        let(:date) { DateTime.parse('2021-01-01 23:59:59-0800') }
        let(:expected_value) { 44_197.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-01-01 00:00:01-0800' do
        let(:date) { DateTime.parse('2021-01-01 00:00:01-0800') }
        let(:expected_value) { 44_197.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-06-01 23:59:59-0700' do
        let(:date) { DateTime.parse('2021-06-01 23:59:59-0700') }
        let(:expected_value) { 44_348.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-06-01 00:00:01-0700' do
        let(:date) { DateTime.parse('2021-06-01 00:00:01-0700') }
        let(:expected_value) { 44_348.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end
    end

    describe '#gs_to_datetime' do
      subject { converter.gs_to_datetime(gs_datetime_value) }
      let(:tolerance) { 0.001 }

      let(:expected_value) do
        ActiveSupport::TimeZone.new(time_zone_name).parse(formatted_cell_value).to_datetime
      end

      context 'when gs_datetime_value is nil' do
        let(:gs_datetime_value) { nil }
        it 'should return nil' do
          expect(subject).to eq(nil)
        end
      end
      context 'when gs_datetime_value is an empty string' do
        let(:gs_datetime_value) { '' }
        it 'should return nil' do
          expect(subject).to eq(nil)
        end
      end
      context 'when the cell displays "2021-05-18 01:00:00"' do
        let(:gs_datetime_value) { 44_334.04166667 }
        let(:formatted_cell_value) { '2021-05-18 01:00:00' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(-7.0 / 24)
        end
      end

      context 'when the cell displays "2021-05-18 23:00:00"' do
        let(:gs_datetime_value) { 44_334.95833333 }
        let(:formatted_cell_value) { '2021-05-18 23:00:00' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(-7.0 / 24)
        end
      end

      context 'when the cell displays "2021-01-01 23:59:59"' do
        let(:gs_datetime_value) { 44_197.99998843 }
        let(:formatted_cell_value) { '2021-01-01 23:59:59' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(-8.0 / 24)
        end
      end

      context 'when the cell displays "2021-01-01 00:00:01"' do
        let(:gs_datetime_value) { 44_197.00001157 }
        let(:formatted_cell_value) { '2021-01-01 00:00:01' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(-8.0 / 24)
        end
      end

      context 'when the cell displays "2021-06-01 23:59:59"' do
        let(:gs_datetime_value) { 44_348.99998843 }
        let(:formatted_cell_value) { '2021-06-01 23:59:59' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(-7.0 / 24)
        end
      end

      context 'when the cell displays "2021-06-01 00:00:01"' do
        let(:gs_datetime_value) { 44_348.00001157 }
        let(:formatted_cell_value) { '2021-06-01 00:00:01' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(-7.0 / 24)
        end
      end
    end

    describe '#gs_to_date' do
      subject { converter.gs_to_date(gs_date_value) }
      let(:tolerance) { 0.001 }

      let(:expected_value) do
        ActiveSupport::TimeZone.new(time_zone_name).parse(formatted_cell_value).to_date
      end

      context 'when gs_date_value is nil' do
        let(:gs_date_value) { nil }
        it 'should return nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'when gs_date_value is an empty string' do
        let(:gs_date_value) { '' }
        it 'should return nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'when the cell displays "2021-06-01"' do
        let(:gs_date_value) { 44_348.00000000 }
        let(:formatted_cell_value) { '2021-06-01' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-01-01"' do
        let(:gs_date_value) { 44_197.00000000 }
        let(:formatted_cell_value) { '2021-01-01' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-05-18 01:00:00"' do
        let(:gs_date_value) { 44_334.04166667 }
        let(:formatted_cell_value) { '2021-05-18 01:00:00' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-05-18 23:00:00"' do
        let(:gs_date_value) { 44_334.95833333 }
        let(:formatted_cell_value) { '2021-05-18 23:00:00' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-01-01 23:59:59"' do
        let(:gs_date_value) { 44_197.99998843 }
        let(:formatted_cell_value) { '2021-01-01 23:59:59' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-01-01 00:00:01"' do
        let(:gs_date_value) { 44_197.00001157 }
        let(:formatted_cell_value) { '2021-01-01 00:00:01' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-06-01 23:59:59"' do
        let(:gs_date_value) { 44_348.99998843 }
        let(:formatted_cell_value) { '2021-06-01 23:59:59' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-06-01 00:00:01"' do
        let(:gs_date_value) { 44_348.00001157 }
        let(:formatted_cell_value) { '2021-06-01 00:00:01' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end
    end
  end

  context 'when the spreadsheet has the UTC time zone' do
    let(:time_zone_name) { 'Etc/GMT' }
    it 'should not raise an error' do
      expect { converter }.not_to raise_error
    end

    describe '#datetime_to_gs' do
      subject { converter.datetime_to_gs(date_time) }

      context 'with nil' do
        let(:date_time) { nil }
        it 'should return an empty string' do
          expect(subject).to eq('')
        end
      end

      context 'with DateTime 2021-05-17 18:36:00 UTC' do
        let(:date_time) { DateTime.parse('2021-05-18 1:00:00 UTC') }
        let(:expected_value) { 44_334.04166667 }

        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'with DateTime 2021-05-17 11:36:00-0700' do
        let(:date_time) { DateTime.parse('2021-05-17 11:36:00-0700') }
        let(:expected_value) { 44_333.77500000 }

        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'with DateTime 2021-01-01 11:22:33 UTC' do
        let(:date_time) { DateTime.parse('2021-01-01 0:00:01 UTC') }
        let(:expected_value) { 44_197.00001157 }

        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end
    end

    describe '#date_to_gs' do
      subject { converter.date_to_gs(date) }

      context 'with nil' do
        let(:date) { nil }
        it 'should return an empty string' do
          expect(subject).to eq('')
        end
      end

      context 'with a Date 2021-05-18' do
        let(:date) { Date.parse('2021-05-18') }
        let(:expected_value) { 44_334.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-05-18 01:00:00 UTC' do
        let(:date) { DateTime.parse('2021-05-18 01:00:00 UTC') }
        let(:expected_value) { 44_334.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-05-18 23:00:00 UTC' do
        let(:date) { DateTime.parse('2021-05-18 23:00:00 UTC') }
        let(:expected_value) { 44_334.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-01-01 23:59:59-0800' do
        let(:date) { DateTime.parse('2021-01-01 23:59:59-0800') }
        let(:expected_value) { 44_198.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-01-01 00:00:01-0800' do
        let(:date) { DateTime.parse('2021-01-01 00:00:01-0800') }
        let(:expected_value) { 44_197.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-06-01 23:59:59-0700' do
        let(:date) { DateTime.parse('2021-06-01 23:59:59-0700') }
        let(:expected_value) { 44_349.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end

      context 'when a DateTime 2021-06-01 00:00:01-0700' do
        let(:date) { DateTime.parse('2021-06-01 00:00:01-0700') }
        let(:expected_value) { 44_348.00000000 }
        it 'should return the expected value' do
          expect(subject).to be_within(tolerance).of(expected_value)
        end
      end
    end

    describe '#gs_to_datetime' do
      subject { converter.gs_to_datetime(gs_datetime_value) }
      let(:tolerance) { 0.001 }

      let(:expected_value) do
        ActiveSupport::TimeZone.new(time_zone_name).parse(formatted_cell_value).to_datetime
      end

      context 'when gs_datetime_value is nil' do
        let(:gs_datetime_value) { nil }
        it 'should return nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'when gs_datetime_value is an empty string' do
        let(:gs_datetime_value) { '' }
        it 'should return nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'when gs_datetime_value is a string other than an empty string' do
        let(:gs_datetime_value) { 'bogus string' }
        it 'should raise an error' do
          expect { subject }.to raise_error(RuntimeError)
        end
      end

      context 'when the cell displays "2021-05-18 01:00:00"' do
        let(:gs_datetime_value) { 44_334.04166667 }
        let(:formatted_cell_value) { '2021-05-18 01:00:00' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(0)
        end
      end

      context 'when the cell displays "2021-05-18 23:00:00"' do
        let(:gs_datetime_value) { 44_334.95833333 }
        let(:formatted_cell_value) { '2021-05-18 23:00:00' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(0)
        end
      end

      context 'when the cell displays "2021-01-01 23:59:59"' do
        let(:gs_datetime_value) { 44_197.99998843 }
        let(:formatted_cell_value) { '2021-01-01 23:59:59' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(0)
        end
      end

      context 'when the cell displays "2021-01-01 00:00:01"' do
        let(:gs_datetime_value) { 44_197.00001157 }
        let(:formatted_cell_value) { '2021-01-01 00:00:01' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(0)
        end
      end

      context 'when the cell displays "2021-06-01 23:59:59"' do
        let(:gs_datetime_value) { 44_348.99998843 }
        let(:formatted_cell_value) { '2021-06-01 23:59:59' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(0)
        end
      end

      context 'when the cell displays "2021-06-01 00:00:01"' do
        let(:gs_datetime_value) { 44_348.00001157 }
        let(:formatted_cell_value) { '2021-06-01 00:00:01' }
        it 'should return the expected DateTime' do
          expect(subject).to be_kind_of(DateTime)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
          expect(subject.offset).to eq(0)
        end
      end
    end

    describe '#gs_to_date' do
      subject { converter.gs_to_date(gs_date_value) }
      let(:tolerance) { 0.001 }

      let(:expected_value) do
        ActiveSupport::TimeZone.new(time_zone_name).parse(formatted_cell_value).to_date
      end

      context 'when gs_date_value is nil' do
        let(:gs_date_value) { nil }
        it 'should return nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'when gs_date_value is an empty string' do
        let(:gs_date_value) { '' }
        it 'should return nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'when gs_date_value is a string other than an empty string' do
        let(:gs_date_value) { 'bogus string' }
        it 'should raise an error' do
          expect { subject }.to raise_error(RuntimeError)
        end
      end

      context 'when the cell displays "2021-06-01"' do
        let(:gs_date_value) { 44_348.00000000 }
        let(:formatted_cell_value) { '2021-06-01' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-01-01"' do
        let(:gs_date_value) { 44_197.00000000 }
        let(:formatted_cell_value) { '2021-01-01' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-05-18 01:00:00"' do
        let(:gs_date_value) { 44_334.04166667 }
        let(:formatted_cell_value) { '2021-05-18 01:00:00' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-05-18 23:00:00"' do
        let(:gs_date_value) { 44_334.95833333 }
        let(:formatted_cell_value) { '2021-05-18 23:00:00' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-01-01 23:59:59"' do
        let(:gs_date_value) { 44_197.99998843 }
        let(:formatted_cell_value) { '2021-01-01 23:59:59' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-01-01 00:00:01"' do
        let(:gs_date_value) { 44_197.00001157 }
        let(:formatted_cell_value) { '2021-01-01 00:00:01' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-06-01 23:59:59"' do
        let(:gs_date_value) { 44_348.99998843 }
        let(:formatted_cell_value) { '2021-06-01 23:59:59' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end

      context 'when the cell displays "2021-06-01 00:00:01"' do
        let(:gs_date_value) { 44_348.00001157 }
        let(:formatted_cell_value) { '2021-06-01 00:00:01' }
        it 'should return the expected Date' do
          expect(subject).to be_kind_of(Date)
          expect(subject.to_time).to be_within(tolerance).of(expected_value.to_time)
        end
      end
    end
  end
end
