RSpec::Matchers.define :have_editable_property do |property, predicate|
  match do |model|
    values = ['Comet in Moominland', 'Moomin Midwinter']

    expect { model.public_send("#{property}=", values) }
      .to change { model.public_send(property).to_a }
      .to contain_exactly(*values)

    expect(model.resource.statements)
      .to include(RDF::Statement(model.rdf_subject,
                                 predicate,
                                 'Comet in Moominland'),
                  RDF::Statement(model.rdf_subject,
                                 predicate,
                                 'Moomin Midwinter'))
    true
  end
end
