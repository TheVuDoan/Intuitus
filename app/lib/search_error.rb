class SearchError < StandardError
  attr_accessor :error_status
  attr_accessor :user_message

  def initialize(error_message = nil, user_message = nil, status = nil)
    @error_status = status if status.present?
    @user_message = user_message if user_message.present?

    super(error_message)
  end
end
