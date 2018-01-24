# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'mahonia:import:bepress_csv', :clean do
  include_context 'rake'

  subject(:task)  { rake[name] }
  let(:task_path) { 'lib/tasks/import' }
  let(:csv_path)  { 'spec/fixtures/bepress_etd_sample.csv' }

  it 'outputs info to stdout' do
    expect { task.invoke(csv_path) }
      .to output(/^Record created/)
      .to_stdout_from_any_process
  end

  it 'creates exactly 3 Etds' do
    expect { task.invoke(csv_path) }
      .to change { Etd.count }
      .by(3)
  end

  context 'with an invalid file' do
    let(:csv_path) { 'spec/fixtures/malformed.csv' }

    it 'outputs validation failures to stdout' do
      expect { task.invoke(csv_path) }
        .to output(/MalformedCSV.*line 2/)
        .to_stdout_from_any_process
    end

    it 'does not create items' do
      expect { task.invoke(csv_path) }
        .not_to change { Etd.count }
    end
  end

  context 'with a missing filenames' do
    let(:csv_path) { "#{fixture_path}/missing_file.csv" }

    it 'outputs validation failures to stdout' do
      expect { task.invoke(csv_path) }
        .to output(/^missing_file.*^missing_file.*^file_not_readable.*/m)
        .to_stdout_from_any_process
    end

    it 'does not create items' do
      expect { task.invoke(csv_path) }
        .not_to change { Etd.count }
    end
  end
end
