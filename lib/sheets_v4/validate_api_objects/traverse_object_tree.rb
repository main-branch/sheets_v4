# frozen_string_literal: true

module SheetsV4
  module ValidateApiObjects
    # Visit all objects in arbitrarily nested object tree of hashes and/or arrays
    #
    # @api public
    #
    class TraverseObjectTree
      # Visit all objects in arbitrarily nested object tree of hashes and/or arrays
      #
      # For each object, the visitor is called with the path to the object and the object
      # itself.
      #
      # In the examples below assume the elided code is the following:
      #
      # ```Ruby
      # visitor = -> (path:, object:) { puts "path: #{path}, object: #{obj}" }
      # SheetsV4::ValidateApiObjects::TraverseObjectTree.call(object:, visitor:)
      # ```
      #
      # @example Given a simple object (not very exciting)
      #   object = 1
      #   ...
      #   #=> path: [], object: 1
      #
      # @example Given an array
      #   object = [1, 2, 3]
      #   ...
      #   #=> path: [], object: [1, 2, 3]
      #   #=> path: [0], object: 1
      #   #=> path: [1], object: 2
      #   #=> path: [2], object: 3
      #
      # @example Given a hash
      #   object = { name: 'James', age: 42 }
      #   ...
      #   #=> path: [], object: { name: 'James', age: 42 }
      #   #=> path: [:name], object: James
      #   #=> path: [:age], object: 42
      #
      # @example Given an array of hashes
      #   object = [{ name: 'James', age: 42 }, { name: 'Jane', age: 43 }]
      #   ...
      #   #=> path: [], object: [{ name: 'James', age: 42 }, { name: 'Jane', age: 43 }]
      #   #=> path: [0], object: { name: 'James', age: 42 }
      #   #=> path: [0, :name], object: James
      #   #=> path: [0, :age], object: 42
      #   #=> path: [1], object: { name: 'Jane', age: 43 }
      #   #=> path: [1, :name], object: Jane
      #   #=> path: [1, :age], object: 43
      #
      # @example Given a hash of hashes
      #   object = { person1: { name: 'James', age: 42 }, person2: { name: 'Jane', age: 43 } }
      #   ...
      #   #=> path: [], object: { person1: { name: 'James', age: 42 }, person2: { name: 'Jane', age: 43 } }
      #   #=> path: [:person1], object: { name: 'James', age: 42 }
      #   #=> path: [:person1, :name], object: James
      #   #=> path: [:person1, :age], object: 42
      #   #=> path: [:person2], object: { name: 'Jane', age: 43 }
      #   #=> path: [:person2, :name], object: Jane
      #   #=> path: [:person2, :age], object: 43
      #
      # @param path [Array] the path to the object
      # @param object [Object] the object to visit
      # @param visitor [#call] the visitor to call for each object
      #
      # @return [void]
      #
      # @api public
      #
      def self.call(object:, visitor:, path: [])
        visitor&.call(path:, object:)
        if object.is_a? Hash
          object.each { |k, obj| call(path: (path + [k]), object: obj, visitor:) }
        elsif object.is_a? Array
          object.each_with_index { |obj, k| call(path: (path + [k]), object: obj, visitor:) }
        end
      end
    end
  end
end
