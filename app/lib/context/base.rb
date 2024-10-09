class Context::Base
  attr_accessor :keyword, :options, :start, :page, :rows, :track_total_hits

  SEARCH_PARAMS_DEFAULT_ROWS = 20

  def initialize(params)
    @options = params[:options].present? ? params[:options].clone : {}
    @page = params[:page] || 1
    @start = @page.to_i > 1 ? (@page.to_i - 1) * SEARCH_PARAMS_DEFAULT_ROWS : 0
    @rows = SEARCH_PARAMS_DEFAULT_ROWS
    @keyword = params[:keyword].present? && params[:keyword].to_s.strip

    @track_total_hits = true
  end

  def homepage?
    false
  end

  def sort_newest?
    @options[:sort] == "newest"
  end

  def sort_oldest?
    @options[:sort] == "oldest"
  end
end
