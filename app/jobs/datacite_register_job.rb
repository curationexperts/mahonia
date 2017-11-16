class DataciteRegisterJob < ApplicationJob
  ##
  # @!attribute [rw] registrar_opts
  attr_accessor :registrar_opts

  queue_as :id_service

  ##
  # @param model [ActiveFedora::Base]
  def perform(model)
    Mahonia::IdentifierDispatcher
      .for(:datacite, **registrar_opts)
      .assign_for!(object: model)
  end
end
