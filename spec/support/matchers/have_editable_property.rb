RSpec::Matchers.define :have_editable_property do |property, predicate|
  match do |model|
    # @todo deprecate two-argument call style in favor chaining
    predicate ||= chain_predicate
    predicate = RDF::URI.intern(predicate)

    values = ['Comet in Moominland', 'Moomin Midwinter']
    values = values.first if @single

    # find the matching property or set @missing_property to true and fail
    config = model.class.properties.fetch(property.to_s) do
      @missing_property = true
      return false
    end

    # fail if setting the property doesn't change the values
    expect { model.public_send("#{property}=", values) }
      .to change { Array(model.public_send(property)) }
      .to contain_exactly(*values)

    # if we haven't failed yet, succeed unless we are verifying the predicate
    return true unless predicate

    # fail if the configured predicate is wrong
    @actual_predicate = config.predicate
    return false unless @actual_predicate == predicate

    # fail if the rdf doesn't have the correct statements
    Array(values).each do |value|
      expect(model.resource.statements)
        .to include(RDF::Statement(model.rdf_subject, predicate, value))
    end

    true
  end

  chain :with_predicate, :chain_predicate

  chain :as_single_valued do
    @single = true
  end

  failure_message do |model|
    msg = "expected #{model.class} to have an editable property `#{property}`"
    msg += " with predicate #{predicate.to_base}." if predicate

    return msg + "\n\tNo property for `#{property}` was found." if @missing_property

    msg += "\n\tThe configured predicate was #{@actual_predicate.to_base}" unless @actual_predicate == predicate
    msg
  end
end
