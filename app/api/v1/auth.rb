module V1
  class Auth < Grape::API

    helpers do
      def serialize(resource)
        UserSerializer.new(
          resource
        )
      end
    end

    resource :auth do
      desc "User login", {
        success: { model: UserSerializer, message: "Token generated successfuly" }
      }
      params do
        requires :email, type: String, desc: "User email"
        requires :password, type: String, desc: "User password"
      end

      post :login do
        result = Authentication::UserAuthenticate.call(declared(params), env: env )

        {
          token: result[:token],
          data: UserSerializer.new(result[:user]).serializable_hash[:data]
        }
      end

      desc "Logout user"
      delete :logout do
        raise Errors::MissingUser unless current_user
        env['warden'].logout

        status 204
      end
    end
  end
end
