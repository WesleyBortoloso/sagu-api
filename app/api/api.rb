class Api < Grape::API
  prefix 'api'
  version 'v1', using: :path
  format :json

  helpers AuthHelpers
  helpers JsonapiFiltering

  rescue_from Errors::MissingUser do |e|
    error!({ error: 'Unauthorized', detail: e.message }, 401)
  end

  rescue_from Errors::MissingToken do
    error!({ error: 'MissingToken', detail: 'Authorization token is missing' }, 401)
  end

  rescue_from Errors::UnauthorizedUser do |e|
    error!({ error: 'Unauthorized', detail: e.message }, 401)
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ error: 'Record not found', detail: e.message }, 404)
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error!({ error: 'Validation failed', detail: e.message }, 400)
  end

  rescue_from :all do |e|
    error!({ error: 'Internal server error', detail: e.message }, 500)
  end

  helpers do
    def valid_api_key?
      headers['X-API-KEY'] == ENV['MY_API_KEY']
    end
  end

  helpers do
    def require_manager!
      unless current_user.is_a?(Staff) && current_user.role_manager?
        error!({ error: "Somente gestores podem realizar essa ação" }, 403)
      end
    end
  end

  mount V1::Base
end
