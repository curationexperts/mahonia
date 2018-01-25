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
    license: "distribution_license",
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
    return if metadata['author1_fname'].nil? && metadata['author1_lname'].nil?
    Array("#{metadata['author1_fname']} #{metadata['author1_lname']}")
  end

  def publisher
    ["OHSU Scholar Archive"]
  end

  def representative_file
    @metadata['file_name']
  end

  def map_field(name)
    return unless BEPRESS_TERMS_MAP.keys.include?(name)
    # Multivalue fields can be present in rows.
    # When they occur, they have integers appended to
    # them: name1, name2. We check for multiple occurances
    # of the name and integers (optionally), and return the
    # values in an array
    metadata.select do |k, val|
      val if k.match?(/^#{BEPRESS_TERMS_MAP[name]}[0-9]*$/)
    end.values
  end
end
