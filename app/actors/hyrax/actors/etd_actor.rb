# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Etd`
module Hyrax
  module Actors
    class EtdActor < Hyrax::Actors::BaseActor
      include Mahonia::MeshTermService

      # Go through the subject attributes when creating and replace with URIs if appropriate
      # @param [Hyrax::Actors::Environment]
      def create(env)
        uris_for_labels(env)
        super
      end

      # Go through the subject attributes when updating and replace with URIs if appropriate
      # @param [Hyrax::Actors::Environment]
      def update(env)
        uris_for_labels(env)
        super
      end

      private

        # Go through the subject attributes and replace with URIs if appropriate
        # @param [Hyrax::Actors::Environment]
        # @return [Boolean]
        def uris_for_labels(env)
          if env.attributes&.dig(:subject)
            env.attributes[:subject] = labels_to_uris(env.attributes.dig(:subject))
          end
          true
        end
    end
  end
end
