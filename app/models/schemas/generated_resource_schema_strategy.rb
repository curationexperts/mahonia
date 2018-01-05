# frozen_string_literal: true
module Schemas
  ##
  # An extension strategy to apply schema changes to the underlying AT model if it
  # has already been generated.
  class GeneratedResourceSchemaStrategy < ActiveFedora::SchemaIndexingStrategy
    ##
    # @see SchemaIndexingStrategy#apply
    def apply(object, property)
      result = super

      klass = class_for(object: object)
      return result unless klass

      klass.property property.name, property.to_h
      result
    end

    ##
    # Delete a property.
    #
    # @param object        [Class]
    # @param property_name [#to_s]
    #
    # @return [void]
    def delete(object, property_name)
      property_name = property_name.to_s

      object.properties.delete(property_name) &&
        object.attribute_names.delete(property_name) &&
        object.delegated_attributes.delete(property_name)

      class_for(object: object)&.properties&.delete(property_name)
    end

    private

      def class_for(object:)
        object.instance_variable_get(:@generated_resource_class)
      end
  end
end
