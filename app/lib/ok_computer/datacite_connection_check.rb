# frozen_string_literal: true
require 'honeybadger'

module OkComputer
  class DataciteConnectionCheck < OkComputer::Check
    attr_accessor :connection, :datacite_doi

    def check
      @connection ||= Datacite::Connection.new
      record = Datacite::Connection::ResponseRecord
               .new(@datacite_doi || '10.5072/MOOMIN_ID')

      @connection.create(metadata: record)
      @connection.get(metadata: record)
    rescue => exception
      Honeybadger.notify(exception)
      mark_failure
      mark_message "Cannot connect to DataCite:\n\t#{exception.message}"
    end
  end
end
