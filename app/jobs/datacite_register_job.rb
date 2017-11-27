# frozen_string_literal: true
class DataciteRegisterJob < ApplicationJob
  ##
  # @!attribute [rw] registrar_opts
  attr_writer :registrar_opts

  def registrar_opts
    @registrar_opts ||= {}
  end

  queue_as :id_service

  ##
  # @param model [ActiveFedora::Base]
  def perform(model)
    Mahonia::IdentifierDispatcher
      .for(:datacite, **registrar_opts)
      .assign_for!(object: model)
  end
end
