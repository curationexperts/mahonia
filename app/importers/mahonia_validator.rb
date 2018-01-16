# frozen_string_literal: true
class MahoniaValidator < Darlingtonia::Validator
  def validate(metadata)
    errors = []
    errors << Error.new(self, :missing_title, "title is required") if metadata[:title].nil?
    errors
  end
end
