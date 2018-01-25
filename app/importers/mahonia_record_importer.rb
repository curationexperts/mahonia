# frozen_string_literal: true

##
# A `Darlingtonia::RecordImporter` that processes files and passes new works
# through the Actor Stack for creation.
class MahoniaRecordImporter < Darlingtonia::RecordImporter
  ##
  # @!attribute [rw] creator
  #   @return [User]
  # @!attribute [rw] file_path
  #   @return [String]
  attr_accessor :creator, :file_path

  ##
  # @param file_path [String]
  # @param creator   [User]
  def initialize(**opts)
    self.creator   = opts.delete(:creator)   || raise(ArgumentError)
    self.file_path = opts.delete(:file_path) || raise(ArgumentError)
    super
  end

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

    def file_for(filename)
      Hyrax::UploadedFile
        .create(file: File.open(file_path + filename), user: creator)
    end
end
