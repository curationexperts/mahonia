# frozen_string_literal: true
class ApplicationJob < ActiveJob::Base
  KNOWN_QUEUES = [:default, :id_service].freeze

  rescue_from ActiveJob::DeserializationError do |exception|
    raise exception unless exception.cause.is_a? Ldp::Gone

    logger.warn "#{self.class} with id #{job_id} failed with #{exception.cause}." \
                "The object passed to the job no longer exists.\n\t#{exception}\n\t"
  end

  class << self
    ##
    # @return [Array<Symbol>] names of all known queues
    def known_queues
      KNOWN_QUEUES
    end

    def queue_as(name, *)
      return super if known_queues.include?(name)

      raise ArgumentError, "#{name} is not a known queue name. Named job queues " \
                           "must be explictly setup to run in the development " \
                           "and production environments for jobs enqueued with " \
                           "them to run. Add a `[#{name}, priority] pair to " \
                           "`config/sidekiq.yml`. Then remove this warning by " \
                           "adding #{name} to `ApplicationJob::KNOWN_QUEUES`."
    end
  end
end
