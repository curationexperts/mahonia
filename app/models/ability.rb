# frozen_string_literal: true
class Ability
  include Hydra::Ability

  include Hyrax::Ability
  # Remove Hyrax default behavior. In Mahonia, only admin users can create works.
  # self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions
    if current_user.admin? # rubocop:disable Style/GuardClause
      can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
    end
    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end
end
