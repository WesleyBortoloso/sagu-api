class Occurrency::Update < BaseInteraction
  attr_reader :occurrency

  def call
    find_occurrency!
    update_occurrency!
    create_event!

    occurrency
  end

  private

  def find_occurrency!
    @occurrency = Occurrency.find(params[:occurrency_id])
  end

  def update_occurrency!
    occurrency.update!(allowed_params)
  end

  def allowed_params
    params.slice(:responsible_id, :status, :kind, :severity).compact
  end

  def create_event!
    return if occurrency.previous_changes.blank?

    changed_fields = occurrency.previous_changes.keys - %w[updated_at]
    return if changed_fields.empty?

    Event::Create.call({
      eventable: occurrency,
      user: current_user,
      target: occurrency.responsible,
      description: description(changed_fields)
    })
  end

  def description(changed_fields)
    ::UpdateEventDescriptionFactory.call(resource: occurrency, changed_fields: changed_fields)
  end
end
