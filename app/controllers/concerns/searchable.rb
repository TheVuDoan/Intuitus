module Searchable
  def generate_homepage_context
    @context = Context::Homepage.new(params.permit!.to_h.deep_symbolize_keys)
  end

  def generate_search_context
    params[:options] = generate_params_options
  
    @context = Context::Search.new(params.permit!.to_h.deep_symbolize_keys)
  end

  def execute_search
    if @blank_keyword
      @num_found = 0
    else
      os_client = Opensearch::Client.new(@context)
      response = os_client.search
      @num_found = response.found
      # TODO: We are not saving url in OS, so we need to fetch it from DB. Need refactor
      os_posts = response.format
      db_posts = Post.includes(:source).where(
        id: os_posts.map { |hash| hash[:id] }
      )
      @posts = os_posts.map do |os_post|
        db_post = db_posts.find { |db_post| db_post.id == os_post[:id] }
        {
          id: os_post[:id],
          title: os_post[:title],
          description: os_post[:description],
          source: db_post.source.name,
          publish_date: os_post[:publish_date],
          link: db_post.link
        }
      end
    end
  end

  def prepare_render_data
    @keyword = params[:keyword]
    @sources = Source.all

    if @blank_keyword
      @posts = []
    else
      @posts = Kaminari.paginate_array(@posts, total_count: @num_found)
                       .page(@context.page)
                       .per(Context::Base::SEARCH_PARAMS_DEFAULT_ROWS)
    end
  end

  private

  def generate_params_options
    options = {}
    options[:source] = params[:source] if params[:source].present?
    options[:sort] = params[:sort] if params[:sort].present?
    options
  end
end
