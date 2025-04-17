module Errors
  class UnauthorizedUser < Errors::Base
    def initialize
      super('Usuário não autorizado!')
    end

    def status_code
      401
    end
  end
end
