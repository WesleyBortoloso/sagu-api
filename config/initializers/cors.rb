Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # Change '*' to your frontend domain in production
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization']
  end
end
