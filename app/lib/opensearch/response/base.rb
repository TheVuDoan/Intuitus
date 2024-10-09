# frozen_string_literal: true

module Opensearch::Response
  class Base
    include Opensearch

    attr_reader :found
    attr_accessor :documents

    def initialize(data, context)
      if context.track_total_hits
        @found = data["hits"]["total"]["value"]
      else
        @found = data["hits"]["hits"].length
      end

      @context = context
      @documents = data["hits"]["hits"]
    end

    def has_error?
      false
    end

    def format
      @documents.map do |document|
        {
          id: document["_id"].to_i,
          title: document["_source"]["title"],
          description: document["_source"]["description"],
          source: document["_source"]["source"],
          publish_date: document["_source"]["publish_date"]
        }
      end
    end

    def self.parse_response(data, context)
      return Error.new(data) if data["error"]

      self.new(data, context)
    end
  end
end
