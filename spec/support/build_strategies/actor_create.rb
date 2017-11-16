class ActorCreate
  def initialize
    @assciation_strategy = FactoryBot.strategy_by_name(:create).new
  end

  delegate :association, to: :@association_strategy

  def result(evaluation)
    evaluation.object.tap do |instance|
      evaluation.notify(:after_build, instance)

      # @todo: is there a better way to get the evaluator at this stage?
      #   how should we handle a missing user?
      ability = Ability.new(evaluation.instance_variable_get(:@evaluator).user)
      env     = Hyrax::Actors::Environment.new(instance, ability, {})
      # @todo: generalize to use correct actors and middleware
      actor   = Hyrax::Actors::EtdActor.new(Hyrax::Actors::Terminator.new)

      evaluation.notify(:before_create,       instance)
      evaluation.notify(:before_actor_create, instance)
      actor.create(env)
      evaluation.notify(:after_create,       instance)
      evaluation.notify(:after_actor_create, instance)
    end
  end
end
