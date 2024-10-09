module Checkable
  def check_keyword
    @blank_keyword = params[:keyword].to_s.blank?
  end
end
