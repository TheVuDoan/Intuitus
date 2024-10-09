class HomeController < ApplicationController
  include Searchable
  include Checkable

  def index
    generate_homepage_context
    execute_search
  end
end
