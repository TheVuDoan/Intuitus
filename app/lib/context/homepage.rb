class Context::Homepage < Context::Base
  def initialize(params)
    super(params)

    @rows = 10
    @track_total_hits = false
  end

  def homepage?
    true
  end

  def sort_newest?
    true
  end
end