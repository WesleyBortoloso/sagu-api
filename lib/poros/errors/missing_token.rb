module Errors
  class MissingToken < Errors::Base
    def initialize
      super('Essa operação necessita um token de autenticação!')
    end

    def status_code
      401
    end
  end
end
