module Opensearch::Query
  class Base
    FIELDS = %w(
      _score
      title
      description
      publish_date
    ).freeze

    def initialize(context)
      @context = context
    end

    def build_query
      query = {
        _source: return_fields,
        from: search_start_at,
        track_total_hits: @context.track_total_hits,
        size: return_size,
      }
      query_body = search_query
      return {} if query_body.blank?

      query.update(query: query_body) if query_body.present?
      query.update(sort: return_order) if add_search_order?

      query
    end

    private

    def return_fields
      [*FIELDS]
    end

    def search_start_at
      @context.start
    end

    def return_size
      @context.rows
    end

    def search_query
      main_query = build_main_query
      return {} if main_query.blank?

      filter_query = build_filter_query

      if filter_query.blank?
        {
          bool: {
            must: main_query
          }
        }
      else
        {
          bool: {
            must: main_query
          }.merge(filter_query)
        }
      end
    end

    def return_order
      raise NotImplementedError
    end

    def build_main_query
      raise NotImplementedError
    end

    def build_filter_query
      raise NotImplementedError
    end

    def add_search_order?
      true
    end
  end
end
