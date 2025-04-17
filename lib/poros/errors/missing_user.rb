module Errors
  class MissingUser < Errors::Base
    def initialize
      super('Essa operação necessita um usuário logado!')
    end

    def status_code
      401
    end
  end
end
