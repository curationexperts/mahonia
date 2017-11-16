module Mahonia
  ##
  # Builds an identifier string.
  #
  # @example
  #   builder = IdentifierBuilder.new(prefix: 'moomin')
  #   builder.build(hint: '1') # => "moomin/1"
  class IdentifierBuilder
    ##
    # @!attribute prefix [rw]
    #   @return [String] the prefix to use when building identifiers
    attr_accessor :prefix

    ##
    # @param prefix [String] the prefix to use when building identifiers
    def initialize(prefix: 'pfx')
      @prefix = prefix
    end

    ##
    # @note this default builder requires a `hint` which it appends to the
    #   prefix to generate the identifier string.
    #
    # @param hint [#to_s] a string-able object which may be used by the builder
    #   to generate an identifier. Hints may be required by some builders, while
    #   others may ignore them to generate an identifier by other means.
    #
    # @return [String]
    # @raise [ArgumentError] if an identifer can't be built from the provided
    #   hint.
    def build(hint: nil)
      raise(ArgumentError, "No hint provided to #{self.class}#build") if
        hint.nil?

      "#{prefix}/#{hint}"
    end
  end
end
