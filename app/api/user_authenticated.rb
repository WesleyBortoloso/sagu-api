module UserAuthenticated
  extend ActiveSupport::Concern

  included do
    before do
      raise Errors::MissingUser unless current_user
    end
  end
end
