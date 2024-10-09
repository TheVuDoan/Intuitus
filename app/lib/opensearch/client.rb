class Opensearch::Client
  # TODO: Rename this for better clarity
  include Opensearch

  def initialize(context)
    @context = context
  end

  def search
    query = build_query(@context)

    if query.present?
      search_items(query.to_json)
    else
      empty_response = {
        "took" => 0,
        "hits" => {
          "total" => {
            "value" => 0,
            "relation" => "eq"
          },
          "max_score" => "null",
          "hits" => []
        }
      }
      Response::Base.parse_response(empty_response, @context)
    end
  end

  private

  def build_query(context)
    items_query = items_query_klass.new(context)

    items_query.build_query
  end

  def items_query_klass
    @context.homepage? ? Query::Homepage::Posts : Query::Search::Posts
  end

  def search_items(query)
    # TODO: Add cache layer
    response = send_search_query(query)
    raise response.reason if response.has_error?

    response
  rescue => ex
    raise build_search_error(ex, "The server encountered an error")
  end

  def send_search_query(query)
    os_client = OpenSearch::Client.new(
      url: Settings.opensearch.url
    )
    index = Settings.opensearch.index

    response = os_client.search(
      index: index,
      body: query
    )

    Response::Base.parse_response(response, @context)
  rescue => ex
    raise build_search_error(ex, "The server encountered an error")
  end

  def build_search_error(ex, title)
    error_message = "#{ex.message}\n #{ex.backtrace.join('\n')}"
    SearchError.new(error_message, title, 503)
  end
end