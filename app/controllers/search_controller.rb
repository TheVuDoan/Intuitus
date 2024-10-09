class SearchController < ApplicationController
  include Searchable
  include Checkable

  def search
    check_keyword
    generate_search_context
    execute_search
    prepare_render_data
  end
end
