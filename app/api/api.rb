class Api < Grape::API
  prefix 'api'
  version 'v1', using: :path
  format :json

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ error: 'Record not found', detail: e.message }, 404)
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error!({ error: 'Validation failed', detail: e.message }, 400)
  end

  rescue_from :all do |e|
    error!({ error: 'Internal server error', detail: e.message }, 500)
  end

  mount V1::Base
end
