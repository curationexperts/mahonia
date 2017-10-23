RSpec::Matchers.define :have_multivalued_field do |name|
  match do |rendered_form|
    raise 'Specify a model with `.on_model(Klass)` to use this matcher.' unless
      model_class

    @selector = "#{model_class.to_s.downcase}_#{name}"
    @field    = rendered_form.find_css("##{@selector}").first

    expect(@field).not_to be_nil

    @multiple = case @field.node_name
                when 'input'
                  @field.attributes['class'].value.include? 'multi_value'
                when 'select'
                  @field.attributes['multiple']
                end

    if label
      @label_text =
        rendered_form.find_css("label[for=\"#{@selector}\"]").try(:text)
      @label_match = @label_text =~ /\s*#{label}\s*/
    end

    @field && @multiple && (!label || @label_match)
  end

  chain :on_model,   :model_class
  chain :with_label, :label

  failure_message do |rendered_form|
    msg = "expected #{rendered_form} to have multivlaued field #{name}"
    msg += " for class #{model_class}"         if     model_class
    msg += " with label #{label}"              if     label
    msg += "\n\tNo field found: #{@selector}." unless @field
    msg += "\n\tField not multivalued."        unless @multiple
    msg += "\n\tLabel was #{@label_text}."     unless @label_match
    msg += "\n\t#{@field}."                    if     @field
    msg
  end
end
