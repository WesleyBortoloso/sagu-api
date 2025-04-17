class BaseInteraction
  attr_accessor :params, :current_user, :options

  delegate :transaction, to: ActiveRecord::Base

  def self.call(params, current_user: nil, **, &)
    new(params, current_user: current_user, **).call(&)
  end

  def initialize(params, current_user: nil, **options)
    @params = params
    @current_user = current_user
    @options = options
  end

  def call
    handling_errors { NotImplementedError }
  end

  def ensure_current_user!
    raise Errors::MissingUser unless !!current_user
  end

  def valid_current_user?
    current_user && current_user.id.present?
  end

  def handling_errors
    yield
  rescue StandardError => e
    Rails.logger.error "[#{self.class}] #{e.class}: #{e.message}"
    raise e
  end
end
