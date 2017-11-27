# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Etd`

module Hyrax
  class EtdsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Etd

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::EtdPresenter

    def new
      raise Hydra::AccessDenied unless current_ability.admin?
      super
    end

    def create
      raise Hydra::AccessDenied unless current_ability.admin?
      super
    end
  end
end
