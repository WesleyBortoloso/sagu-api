module Errors
  class Base < StandardError
    def initialize(message = nil)
      super
    end

    def status_code
      500
    end
  end
end
