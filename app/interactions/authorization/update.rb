class Authorization::Update < BaseInteraction
  attr_reader :authorization

  def call
    find_authorization!
    update_authorization!
    create_event!

    authorization
  end

  private

  def find_authorization!
    @authorization = Authorization.find(params[:authorization_id])
  end

  def update_authorization!
    authorization.update!(allowed_params)
  end

  def allowed_params
    params.slice(:status).compact
  end

  def create_event!
    return if authorization.previous_changes.blank?

    changed_fields = authorization.previous_changes.keys - %w[updated_at]
    return if changed_fields.empty?

    Event::Create.call({
      eventable: authorization,
      user: current_user,
      target: authorization.parent,
      description: description(changed_fields)
    })
  end

  def description(changed_fields)
    ::UpdateEventDescriptionFactory.call(resource: authorization, changed_fields: changed_fields)
  end
end
