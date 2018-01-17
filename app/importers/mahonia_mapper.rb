# frozen_string_literal: true
class MahoniaMapper < Darlingtonia::HashMapper
  BEPRESS_TERMS_MAP = {
    publication_date: :date,
    title: :title,
    keywords: :keyword,
    subject: :subject,
    document_type: :resource_type,
    degree_name: :degree,
    institution_name: :institution,
    school: :school,
    department: :department,
    identifier: :identifier,
    orcid: :orcid_id,
    language: :language,
    license: :license,
    rights: :rights_statement,
    note: :rights_note,
    abstract: :description,
    journal_title: :source
  }.freeze

  def metadata=(meta)
    be_press_hash = meta.to_h
    @metadata = {}
    be_press_hash.each_key do |k|
      if BEPRESS_TERMS_MAP.keys.include? k.to_sym
        @metadata[BEPRESS_TERMS_MAP[k.to_sym]] = be_press_hash.delete k
      end
    end
  end

  def method_missing(method_name, *args, &block)
    return Array(metadata[method_name]) if fields.include?(method_name)
    super
  end

  def respond_to_missing?(method_name, include_private = false)
    field?(method_name) || super
  end
end
