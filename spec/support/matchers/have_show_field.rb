RSpec::Matchers.define :have_show_field do |name|
  match do |rendered_view|
    @displayed_fields = page.find_css("li.#{name}")

    @exists         = !@displayed_fields.empty?
    @extra_actual   = []
    @extra_expected = []

    if @values
      displayed_values = @displayed_fields.map(&:text)
      @extra_actual    = displayed_values - @values
      @extra_expected  = @values - displayed_values
    end

    @label_exists = rendered_view.find(:xpath, "//th[contains(., \"#{label}\")]") if @label

    @exists && @extra_actual.empty? && @extra_expected.empty? && (!@label || @label_exists)
  end

  chain :and_label,  :label
  chain :with_label, :label

  chain :and_values do |*values|
    @values = values
  end

  chain :with_values do |*values|
    @values = values
  end

  failure_message do |rendered_view|
    msg = "expected #{rendered_view} to have field #{name}"
    msg += " with values #{@values}"                               if     @values
    msg += ' but no field was present.'                            unless @exists
    msg += "\n\t#{@extra_actual} were found in the view."          unless @extra_actual.empty?
    msg += "\n\t#{@extra_expected} were expected but not present." unless @extra_expected.empty?
    msg
  end
end
