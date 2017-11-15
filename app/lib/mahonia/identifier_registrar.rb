module Mahonia
  class IdentifierRegistrar
    class << self
      # @param type [Symbol]
      #
      # @return [IdentifierRegistrar] a  registrar for the given type
      def for(type)
        case type
        when :datacite
          'Mahonia::DataciteRegistrar'.constantize.new
        else
          raise ArgumentError, "IdentifierRegistrar not found to handle #{type}"
        end
      end
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
