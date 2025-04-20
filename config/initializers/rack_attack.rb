class Rack::Attack
  throttle('req/ip', limit: 10, period: 1.second) do |req|
    req.ip
  end

  throttle('logins/ip', limit: 3, period: 20.seconds) do |req|
    if req.path == '/api/v1/auth/login' && req.post?
      req.ip
    end
  end
end
