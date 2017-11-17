# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension(Hydra::ContentNegotiation)

  def date
    self[Solrizer.solr_name('date')]
  end

  def date_label
    self[Solrizer.solr_name('date_label')]
  end

  # first is called at https://github.com/samvera/hyrax/blob/b161167a07650f1b873e2ada838d1784a8db02e1/app/views/shared/_citations.html.erb#L22
  def date_created
    fetch(Solrizer.solr_name('date_created', type: :date), [])
  end

  def degree
    self[Solrizer.solr_name('degree')]
  end

  def department
    self[Solrizer.solr_name('department')]
  end

  def institution
    self[Solrizer.solr_name('institution')]
  end

  def orcid_id
    self[Solrizer.solr_name('orcid_id')]
  end

  def school
    self[Solrizer.solr_name('school')]
  end
end
