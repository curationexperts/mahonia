# frozen_string_literal: true
class Importer < Darlingtonia::Importer
  def initialize(parser:, record_importer: MahoniaRecordImporter.new)
    super
  end
end
