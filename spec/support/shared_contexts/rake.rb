# frozen_string_literal: true

require 'rake'

RSpec.shared_context 'rake' do
  let(:rake) { Rake::Application.new }
  let(:name) { self.class.top_level_description }

  def loaded_files_excluding_current_rake_file
    $LOADED_FEATURES.reject { |file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path,
                                  [Rails.root.to_s],
                                  loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
  end
end
