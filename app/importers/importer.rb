# frozen_string_literal: true
class Importer < Darlingtonia::Importer
  ##
  # @return [Hash<Symbol, Object>]
  def self.config
    Rails.application.config_for(:importer)
  end

  def initialize(parser:, record_importer: default_record_importer)
    super
  end

  def config
    self.class.config
  end

  private

    def default_creator
      User
        .first_or_create!(email: config['username'], password: config['password'])
    end

    def default_record_importer
      MahoniaRecordImporter.new(creator:   default_creator,
                                file_path: config['file_path'])
    end
end
