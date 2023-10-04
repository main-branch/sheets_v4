# frozen_string_literal: true

RSpec.describe SheetsV4::ApiObjectValidation::TraverseObjectTree do
  describe '.call' do
    subject { described_class.call(object:, visitor:) }
    let(:visits) { [] }
    let(:visitor) { ->(path:, object:) { visits << { path:, object: } } }

    context 'when object is a simple object' do
      let(:object) { 1 }
      let(:expected_visits) do
        [
          { path: [], object: 1 }
        ]
      end
      it 'should visit all objects in the tree' do
        subject
        expect(visits).to eq(expected_visits)
      end
    end

    context 'when object is an array' do
      let(:object) { [1, 2, 3] }
      let(:expected_visits) do
        [
          { path: [], object: [1, 2, 3] },
          { path: [0], object: 1 },
          { path: [1], object: 2 },
          { path: [2], object: 3 }
        ]
      end
      it 'should visit all objects in the tree' do
        subject
        expect(visits).to eq(expected_visits)
      end
    end

    context 'when object is a hash' do
      let(:object) { { name: 'James', age: 42 } }
      let(:expected_visits) do
        [
          { path: [], object: { name: 'James', age: 42 } },
          { path: [:name], object: 'James' },
          { path: [:age], object: 42 }
        ]
      end
      it 'should visit all objects in the tree' do
        subject
        expect(visits).to eq(expected_visits)
      end
    end

    context 'when object is an array of hashes' do
      let(:object) { [{ name: 'James', age: 42 }, { name: 'Jane', age: 43 }] }
      let(:expected_visits) do
        [
          { path: [], object: [{ name: 'James', age: 42 }, { name: 'Jane', age: 43 }] },
          { path: [0], object: { name: 'James', age: 42 } },
          { path: [0, :name], object: 'James' },
          { path: [0, :age], object: 42 },
          { path: [1], object: { name: 'Jane', age: 43 } },
          { path: [1, :name], object: 'Jane' },
          { path: [1, :age], object: 43 }
        ]
      end
      it 'should visit all objects in the tree' do
        subject
        expect(visits).to eq(expected_visits)
      end
    end

    context 'when object is a hash of hashes' do
      let(:object) { { person1: { name: 'James', age: 42 }, person2: { name: 'Jane', age: 43 } } }
      let(:expected_visits) do
        [
          { path: [], object: { person1: { name: 'James', age: 42 }, person2: { name: 'Jane', age: 43 } } },
          { path: [:person1], object: { name: 'James', age: 42 } },
          { path: %i[person1 name], object: 'James' },
          { path: %i[person1 age], object: 42 },
          { path: [:person2], object: { name: 'Jane', age: 43 } },
          { path: %i[person2 name], object: 'Jane' },
          { path: %i[person2 age], object: 43 }
        ]
      end
      it 'should visit all objects in the tree' do
        subject
        expect(visits).to eq(expected_visits)
      end
    end
  end
end
