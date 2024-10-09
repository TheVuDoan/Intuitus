# frozen_string_literal: true

module Opensearch::Response
  class Error
    attr_reader :reason, :status

    def initialize(data)
      @reason = data["error"]["reason"]
      @status = data["status"]
    end

    def has_error?
      true
    end
  end
end
