# frozen_string_literal: true

namespace :mahonia do
  namespace :import do
    desc 'Run sample import of bepress fixture csv'
    task import_sample_records: :environment do
      parser = MahoniaCsvParser.new(file: File.open('spec/fixtures/bepress_etd_sample.csv'))

      Importer.new(parser: parser).import
    end

    desc 'Batch import of bepress formatted csv'
    task :bepress_csv, [:filename] => [:environment] do |_task, args|
      parser = MahoniaCsvParser.new(file: File.open(args[:filename]))

      Importer.new(parser: parser).import if parser.validate
    end
  end
end
