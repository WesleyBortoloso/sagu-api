class V1::Users < Grape::API
  include UserAuthenticated

  resource :users do
    desc "List all responsible users"
    get :responsible do
      users = User.where(type: %w[Staff Teacher]).order(:name)
  
      present UserSerializer.new(users)
    end
  end
end
