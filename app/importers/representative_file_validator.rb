# frozen_string_literal: true

##
# A validator to ensures that each imported record has an import
class RepresentativeFileValidator < Darlingtonia::Validator
  private

    ##
    # @private
    def run_validation(parser:)
      parser.records.each_with_object([]) do |record, errors|
        if record.representative_file.blank?
          errors <<
            Error.new(self, :missing_file, missing_message_for(record: record))
        else
          filename = record.representative_file
          next if File.exist?(path_for(filename: filename))
          errors <<
            Error.new(self,
                      :file_not_readable,
                      not_readable_message_for(filename: filename))
        end
      end
    end

    def missing_message_for(record:)
      "No `file_name` value is present for imported record: #{record.title}\n" \
      "\tEach record must have a representative file to be successfully imported."
    end

    def not_readable_message_for(filename:)
      "No file was found on disk for file: #{filename}\n\tExpected to find " \
      "the file at the configured path: #{path_for(filename: filename)}"
    end

    def path_for(filename:)
      "spec/fixtures/#{filename}"
    end
end
