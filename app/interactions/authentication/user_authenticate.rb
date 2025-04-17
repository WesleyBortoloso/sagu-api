module Authentication
  class UserAuthenticate < BaseInteraction
    attr_accessor :user, :token

    def call
      ensure_user!
      validate_user_password!
      set_user_token

      auth_data
    end

    private

    def ensure_user!
      @user ||= User.find_by(email: params[:email])
    end

    def validate_user_password!
      raise Errors::UnauthorizedUser unless user&.valid_password?(params[:password])
    end

    def set_user_token
      env['warden'].set_user(user)
      @token ||= env['warden-jwt_auth.token']
    end

    def auth_data
      { user:, token: }
    end

    def env
      options[:env]
    end
  end
end
