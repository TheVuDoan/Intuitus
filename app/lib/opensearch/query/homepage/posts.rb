# frozen_string_literal: true

module Opensearch::Query
  class Homepage::Posts < Base
    def initialize(context)
      super
    end

    private

    def return_order
      [{ publish_date: { "order": "desc" } }]
    end

    def build_filter_query
      {}
    end

    def build_main_query
      {
        match_all: {}
      }
    end
  end
end
