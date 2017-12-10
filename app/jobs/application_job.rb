# frozen_string_literal: true

##
# A base class for jobs defined at the application layer of a Hyrax app. This
# class and documentation are written with SideKiq in mind as the Queue Adapter
# backend for ActiveJob. Using other backends (e.g. Resque) should be possible
# with some differences in behavior.
#
# ### Queue Registration
#
# Jobs can run on various named queues, which can be configured in SideKiq to
# run on different servers, or with different priority levels. It's necessary
# when configuring a new queue name to ensure that the queue is setup to run in
# development and production environments (the test `QueueAdapter` won't catch
# missing queues). To avoid accidentally un- or under-configured queues, we
# require adding a queue name to `.known_queues` before configuring it as the
# default queue for the class. If `.queue_as` is called with an unknown queue
# name, an error is raised.
#
# Ad-hoc queue names can still be used on a per-job basis (e.g.
# `MyJob.set(queue: :new_queue).perform_later(*args)`) or set dynamically with
# a block (`queue_as do; ...; end`).
#
# ### Error Handling & Job Retries
#
# Errors sometimes happen in job processing. In the normal case, our strategy
# for handling these errors is to allow them to pass through to the job queue
# backend, where they can be automatically retried.
#
# SideKiq holds onto failed jobs and retries them with an increasing time delay,
# about 25 times in 21 days. Jobs can also be retried manually from the SideKiq
# web UI. If Honeybadger is enabled it will track the errors coming from jobs.
# These two interfaces make up our strategy for tracking and handling job
# failures. Some failures may require action to resolve, either through quality
# control of repository content or deploying bug fixes.
#
# When an error should not be retried, job classes can handle the error
# directly; e.g. with `rescue_from ErrorClass`. Doing so will avoiding
# notifications and retries. Jobs inheriting from this base class handle and log
# errors resulting from deleted repository content
# (`ActiveJob::DeserializationError` caused by `Ldp::Gone`), for jobs that
# require access to permanently deleted content.
#
# @example
#   class MyJob < ApplicationJob
#     def perform(model, options)
#       do_work(model, options)
#     end
#   end
#
# @see http://guides.rubyonrails.org/v5.0/active_job_basics.html
# @see https://github.com/mperham/sidekiq/wiki/Error-Handling
class ApplicationJob < ActiveJob::Base
  KNOWN_QUEUES = [:default, :id_service].freeze

  ##
  # Rescue `ActiveJob::DeserializationError` log if the cause is `Ldp::Gone`,
  # otherwise re-raise.
  rescue_from ActiveJob::DeserializationError do |exception|
    raise exception unless exception.cause.is_a? Ldp::Gone

    logger.warn "#{self.class} with id #{job_id} failed with #{exception.cause}." \
                "The object passed to the job no longer exists.\n\t#{exception}"
  end

  class << self
    ##
    # @return [Array<Symbol>] names of all known queues
    def known_queues
      KNOWN_QUEUES
    end

    def queue_as(name = nil, *)
      return super if block_given? || known_queues.include?(name)

      message = "#{name} is not a known queue name. Named job queues " \
                "must be explictly setup to run in the development " \
                "and production environments for jobs enqueued with " \
                "them to run. Add a `[#{name}, priority] pair to " \
                "`config/sidekiq.yml`. Then remove this warning by " \
                "adding #{name} to `ApplicationJob::KNOWN_QUEUES`."

      raise ArgumentError, message unless ENV['RAILS_ENV'] == 'production'

      logger.warn(message)
      super
    end
  end
end
