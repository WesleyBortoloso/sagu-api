class Orientation::Update < BaseInteraction
  attr_reader :orientation

  def call
    find_orientation!
    update_orientation!
    create_event!

    orientation
  end

  private

  def find_orientation!
    @orientation = Orientation.find(params[:orientation_id])
  end

  def update_orientation!
    orientation.update!(allowed_params)
  end

  def allowed_params
    params.slice(:responsible_id, :status, :area).compact
  end

  def create_event!
    return if orientation.previous_changes.blank?

    changed_fields = orientation.previous_changes.keys - %w[updated_at]
    return if changed_fields.empty?

    Event::Create.call({
      eventable: orientation,
      user: current_user,
      target: orientation.responsible,
      description: description(changed_fields)
    })
  end

  def description(changed_fields)
    UpdateEventDescriptionFactory.call(resource: orientation, changed_fields: changed_fields)
  end
end
