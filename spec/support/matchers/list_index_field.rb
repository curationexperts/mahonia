RSpec::Matchers.define :list_index_fields do |*names|
  match do |rendered_view|
    @missing_names = decorated_names(names) - labels_for(rendered_view)
    @missing_names.empty?
  end

  match_when_negated do |rendered_view|
    @missing_names = decorated_names(names) - labels_for(rendered_view)
    @not_missing = (decorated_names(names) - @missing_names)
    @not_missing.empty?
  end

  def decorated_names(names)
    names.map { |name| name.end_with?(':') ? name : name + ':' }
  end

  def labels_for(view)
    view.find('.metadata').all('.attribute-label').map(&:text)
  end

  failure_message do |rendered_view|
    msg = "expected #{rendered_view} to list index fields #{names}"
    msg + "\n\tthe fields #{@missing_names} were not present."
  end

  failure_message_when_negated do |rendered_view|
    msg = "expected #{rendered_view} not to list index fields #{names}"
    msg + "\n\tbut #{@not_missing} were present."
  end
end
