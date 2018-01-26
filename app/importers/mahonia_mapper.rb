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

  def creator_name(first_name: first, last_name: last)
    "#{first_name} #{last_name}".strip
  end

  # return first and last names of 1-n authors

  def creator
    creators = []

    number_of_authors = metadata.keys.select do |k|
      k.match?(/^author[0-9]*_lname$/)
    end.count

    (1..number_of_authors).each do |i|
      unless metadata["author#{i}_fname"].nil? && metadata["author#{i}_lname"].nil?
        creators << creator_name(first_name: metadata["author#{i}_fname"], last_name: metadata["author#{i}_lname"])
      end
    end

    return nil if creators.empty?
    creators
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
