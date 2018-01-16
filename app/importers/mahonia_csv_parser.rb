# frozen_string_literal: true

class MahoniaCsvParser < Darlingtonia::CsvParser
  def records
    return enum_for(:records) unless block_given?

    file.rewind
    # use the MahoniaMapper
    CSV.parse(file.read, headers: true).each do |row|
      yield Darlingtonia::InputRecord.from(metadata: row, mapper: MahoniaMapper.new)
    end
  end
end
