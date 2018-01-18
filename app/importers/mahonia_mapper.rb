# frozen_string_literal: true
class MahoniaMapper < Darlingtonia::HashMapper
  BEPRESS_TERMS_MAP = {
    date: "publication_date",
    title: "title",
    keyword: "keywords",
    subject: "subject",
    resource_type: "document_type",
    degree: "degree_name",
    institution: "institution_name",
    school: "school",
    department: "department",
    identifier: "identifier",
    orcid_id: "orcid",
    language: "language",
    license: "license",
    rights_statement: "rights",
    rights_note: "note",
    description: "abstract",
    source: "journal_title",
    creator: "creator"
  }.freeze

  def fields
    BEPRESS_TERMS_MAP.keys.reject do |e|
      next if e == :creator
      metadata[BEPRESS_TERMS_MAP[e]].nil?
    end
  end

  def creator
    return if metadata['author1_fname'].nil? && metadata['author1_lname']
    Array("#{metadata['author1_fname']} #{metadata['author1_lname']}")
  end

  def representative_file
    @metadata['file_name']
  end

  def map_field(name)
    return unless BEPRESS_TERMS_MAP.keys.include?(name)
    Array(metadata[BEPRESS_TERMS_MAP[name]])
  end
end
