module AuthHelpers
  def token
    auth = headers['Authorization'].to_s
    return nil if auth.blank?

    auth.split.last
  end

  def current_user
    raise Errors::MissingToken if token.blank?

    decoder = Warden::JWTAuth::UserDecoder.new
    decoder.call(token, :user, nil)
  rescue StandardError
    raise Errors::MissingUser
  end
end
