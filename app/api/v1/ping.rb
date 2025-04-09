module V1
  class Ping < Grape::API
    desc 'Simple ping endpoint'
    get :ping do
      { message: 'pong' }
    end
  end
end
