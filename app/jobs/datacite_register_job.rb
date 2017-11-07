class DataciteRegisterJob < ApplicationJob
  queue_as :id_service

  ##
  # @param model [ActiveFedora::Base]
  def perform(model)
    Mahonia::IdentifierDispatcher
      .for(:datacite)
      .assign_for!(object: model)
  end
end
