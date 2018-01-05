# frozen_string_literal: true
module Mahonia
  class Terms
    REMOVE_TERMS = [:publisher].freeze
    def self.remove_terms
      REMOVE_TERMS
    end
  end
end
