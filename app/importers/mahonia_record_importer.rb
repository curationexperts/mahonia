# frozen_string_literal: true

##
# A `Darlingtonia::RecordImporter` that processes files and passes new works
# through the Actor Stack for creation.
class MahoniaRecordImporter < Darlingtonia::RecordImporter
  private

    ##
    # @private
    def create_for(record:)
      info_stream << 'Creating record: ' \
                     "#{record.respond_to?(:title) ? record.title : record}."

      created    = import_type.new
      attributes = record.attributes

      attributes[:uploaded_files] = [file_for(record.representative_file).id] if
        record.representative_file

      actor_env = Hyrax::Actors::Environment.new(created,
                                                 ::Ability.new(creator),
                                                 attributes)

      Hyrax::CurationConcern.actor.create(actor_env)

      info_stream << "Record created at: #{created.id}"
    rescue Errno::ENOENT => e
      error_stream << e.message
    end

    ##
    # @todo what creator should we really use for ingested content
    def creator
      @creator ||=
        User.first_or_create!(email: 'import_user@example.com',
                              password: 'password')
    end

    def file_for(filename)
      Hyrax::UploadedFile
        .create(file: File.open(file_path + filename), user: creator)
    end

    ##
    # @todo make this configurable! Point somewhere other than fixtures in
    #   development/production envs.
    def file_path
      'spec/fixtures/'
    end
end
