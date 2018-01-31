# frozen_string_literal: true
require 'honeybadger'

module OkComputer
  class ClamavServiceCheck < OkComputer::Check
    def check
      raise VirusScannerError, 'False positive in example.csv' if
        Mahonia::VirusScanner.new('spec/fixtures/example.csv').infected?

      raise VirusScannerError, 'False negative in virus_check.txt' unless
        Mahonia::VirusScanner.new('spec/fixtures/virus_check.txt').infected?
    rescue => exception
      Honeybadger.notify(exception)
      mark_failure
      mark_message exception.message
    end

    class VirusScannerError < RuntimeError; end
  end
end
