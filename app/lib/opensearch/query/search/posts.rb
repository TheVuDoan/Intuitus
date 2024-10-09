# frozen_string_literal: true

module Opensearch::Query
  class Search::Posts < Base
    def initialize(context)
      super
    end

    private

    def return_order
      if @context.sort_newest?
        [{ publish_date: { "order": "desc" } }]
      elsif @context.sort_oldest?
        [{ publish_date: { "order": "asc" } }]
      else
        [{ _score: { "order": "desc" } }]
      end
    end

    def build_filter_query
      filter_query = []

      filter_query << { term: { source: @context.options[:source] } } if @context.options[:source].present?

      {
        filter: filter_query
      }
    end

    def build_main_query
      {
        bool: {
          should: [
            { match: { title: @context.keyword } },
            { match: { description: @context.keyword } }
          ],
          minimum_should_match: 1
        }
      }
    end
  end
end
