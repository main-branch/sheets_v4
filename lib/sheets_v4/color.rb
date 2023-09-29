# frozen_string_literal: true

require 'json_schemer'

module SheetsV4
  # Predefined color objects
  # @api public
  class Color
    class << self
      # Return a color object for the given name from SheetsV4::COLORS or call super
      #
      # @param method_name [Symbol] the name of the color
      # @param arguments [Array] ignored
      # @param block [Proc] ignored
      # @return [Hash] the color object
      # @api private
      def method_missing(method_name, *arguments, &)
        SheetsV4::COLORS[method_name.to_sym] || super
      end

      # Return true if the given method name is a color name or call super
      #
      # @param method_name [Symbol] the name of the color
      # @param include_private [Boolean] ignored
      # @return [Boolean] true if the method name is a color name
      # @api private
      def respond_to_missing?(method_name, include_private = false)
        SheetsV4::COLORS.key?(method_name.to_sym) || super
      end
    end
  end
end
