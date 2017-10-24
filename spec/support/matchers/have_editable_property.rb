RSpec::Matchers.define :have_editable_property do |property, predicate|
  match do |model|
    values = ['Comet in Moominland', 'Moomin Midwinter']
    values = values.first if @single

    expect { model.public_send("#{property}=", values) }
      .to change { Array(model.public_send(property)) }
      .to contain_exactly(*values)

    Array(values).each do |value|
      expect(model.resource.statements)
        .to include(RDF::Statement(model.rdf_subject, predicate, value))
    end

    true
  end

  chain :as_single_valued do
    @single = true
  end
end
