module V1
  class Auth < Grape::API
    resource :auth do
      desc 'User authentication', {
        success: { model: UserSerializer, message: 'Token generated successfuly' }
      }
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end

      post :login do
        result = Authentication::UserAuthenticate.call(declared(params), env: env )

        {
          token: result[:token],
          data: UserSerializer.new(result[:user]).serializable_hash[:data]
        }
      end
    end
  end
end
