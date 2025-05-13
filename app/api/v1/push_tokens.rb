class V1::PushTokens < Grape::API
  include UserAuthenticated

  resource :push_tokens do
    desc "Update expo push notifications token"
    params do
      requires :expo_token, type: String, desc: "Expo Push Token"
    end

    put do
      current_user.update!(expo_token: params[:expo_token])
      status 204
    end

    desc "List current user expo token"
    get do
      {
        expo_token: current_user&.expo_token
      }
    end
  end
end
