# frozen_string_literal: true

namespace :mahonia do
  namespace :import do
    desc 'Run sample import of bepress fixture csv'
    task import_sample_records: :environment do
      parser = MahoniaCsvParser.new(file: File.open('spec/fixtures/bepress_etd_sample.csv'))
      Importer.new(parser: parser).import
      first = Etd.where(title: "Representations and Circuits for Time Based Computation").first.id
      second = Etd.where(title: "Dielectric functions and optical bandgaps of high-K dielectrics by far ultraviolet spectroscopic ellipsometry").first.id
      third = Etd.where(title: "Laser  Processing  Optimization for Semiconductor Based Devices").first.id
      p "Successfully created three Etds, with these ids: #{first}, #{second}, #{third}"
    end

    task :bepress_csv, [:filename] => [:environment] do |_task, args|
      parser = MahoniaCsvParser.new(file: File.open(args[:filename]))
      parser.validate!

      Importer.new(parser: parser).import
    end
  end
end
