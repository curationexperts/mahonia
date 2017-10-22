RSpec::Matchers.define :have_multivalued_field do |name, opts|
  match do |rendered_form|
    selector = name
    selector = "#{opts[:model_class].to_s.downcase}_#{selector}" if
      opts[:model_class]

    # we're only interested in the first instance of the input field, several
    # will exist if values are already present
    field = rendered_form.find_css("input.#{selector}").first

    expect(field.attributes['class'].value).to include 'multi_value'

    if opts[:label]
      label = rendered_form.find_css("label[for=\"#{selector}\"]")
      expect(label.text).to start_with opts[:label]
    end
  end

  failure_message do |rendered_form|
    msg = "expected #{rendered_form} to have multivlaued field #{name}"
    msg += " for class #{opts[:model_class]}" if opts[:model_class]
    msg += " and label #{opts[:label]}"       if opts[:label]
    msg
  end
end
