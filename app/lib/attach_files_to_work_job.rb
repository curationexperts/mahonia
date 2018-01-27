# frozen_string_literal: true

##
# Class copied from Hyrax at 2f8e8534d95ac7.
#
# Converts UploadedFiles into FileSets and attaches them to works.
class AttachFilesToWorkJob < Hyrax::ApplicationJob
  queue_as Hyrax.config.ingest_queue_name

  # @param [ActiveFedora::Base] work - the work object
  # @param [Array<Hyrax::UploadedFile>] uploaded_files - an array of files to attach
  # rubocop:disable Metrics/MethodLength
  def perform(work, uploaded_files, **work_attributes)
    validate_files!(uploaded_files)
    user = User.find_by_user_key(work.depositor) # BUG? file depositor ignored
    work_permissions = work.permissions.map(&:to_hash)
    metadata = visibility_attributes(work_attributes)
    uploaded_files.each do |uploaded_file|
      virus_check!(uploaded_file)
      actor = Hyrax::Actors::FileSetActor.new(FileSet.create, user)
      actor.create_metadata(metadata)
      actor.create_content(uploaded_file)
      actor.attach_to_work(work)
      actor.file_set.permissions_attributes = work_permissions
      uploaded_file.update(file_set_uri: actor.file_set.uri)
    end
  rescue VirusDetectedError => error
    Rails.logger.error "Virus encountered while processing work #{work.id}.\n" \
                       "\t#{error.message}"
  end
  # rubocop:enable Metrics/MethodLength

  class VirusDetectedError < RuntimeError; end

  private

    def virus_check!(uploaded_file)
      return unless Hydra::Works::VirusCheckerService.file_has_virus?(uploaded_file.file)
      carrierwave_file = uploaded_file.file.file
      carrierwave_file.delete
      raise(VirusDetectedError, carrierwave_file.filename)
    end

    # The attributes used for visibility - sent as initial params to created FileSets.
    def visibility_attributes(attributes)
      attributes.slice(:visibility, :visibility_during_lease,
                       :visibility_after_lease, :lease_expiration_date,
                       :embargo_release_date, :visibility_during_embargo,
                       :visibility_after_embargo)
    end

    def validate_files!(uploaded_files)
      uploaded_files.each do |uploaded_file|
        next if uploaded_file.is_a? Hyrax::UploadedFile
        raise ArgumentError, "Hyrax::UploadedFile required, but #{uploaded_file.class} received: #{uploaded_file.inspect}"
      end
    end
end
