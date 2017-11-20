module Mahonia
  class IdentifierRegistrar
    class << self
      ##
      # @param type [Symbol]
      # @param opts [Hash]
      # @option opts [Mahonia::IdentifierBuilder] :builder
      #
      # @return [IdentifierRegistrar] a  registrar for the given type
      def for(type, **opts)
        case type
        when :datacite
          'Mahonia::DataciteRegistrar'.constantize.new(**opts)
        else
          raise ArgumentError, "IdentifierRegistrar not found to handle #{type}"
        end
      end
    end

    ##
    # @!attribute builder [rw]
    #   @return [Mahonia::IdentifierBuilder]
    attr_accessor :builder

    ##
    # @param builder [Mahonia::IdentifierBuilder]
    def initialize(builder:)
      @builder = builder
    end

    ##
    # @abstract
    #
    # @param object [#id]
    #
    # @return [#identifier]
    # @raise [NotImplementedError] when the method is abstract
    def register!(*)
      raise NotImplementedError
    end
  end
end
