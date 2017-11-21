# frozen_string_literal: true
module Hyrax
  module Actors
    ##
    # An actor that registers a DOI with DataCite.
    #
    # @example use in middleware
    #   stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
    #     # middleware.use OtherMiddleware
    #     middleware.use Hyrax::Actors::DataciteActor
    #     # middleware.use MoreMiddleware
    #   end
    #
    #   env = Hyrax::Actors::Environment.new(object, ability, attributes)
    #   last_actor = Hyrax::Actors::Terminator.new
    #   stack.build(last_actor).create(env)
    #
    # @see https://www.datacite.org/
    class DataciteActor < AbstractActor
      ##
      # @return [Boolean]
      #
      # @see Hyrax::Actors::AbstractActor
      def create(env)
        DataciteRegisterJob.perform_later(env.curation_concern) &&
          next_actor.create(env)
      end
    end
  end
end
