class Schedule::Update < BaseInteraction
  attr_reader :schedule

  def call
    find_schedule!
    update_schedule!
    create_event!

    schedule
  end

  private

  def find_schedule!
    @schedule = Schedule.find(params[:schedule_id])
  end

  def update_schedule!
    schedule.update!(allowed_params)
  end

  def allowed_params
    params.slice(:status, :area).compact
  end

  def create_event!
    return if schedule.previous_changes.blank?

    changed_fields = schedule.previous_changes.keys - %w[updated_at]
    return if changed_fields.empty?

    Event::Create.call({
      eventable: schedule,
      user: current_user,
      target: schedule.parent,
      description: description(changed_fields)
    })
  end

  def description(changed_fields)
    UpdateEventDescriptionFactory.call(resource: schedule, changed_fields: changed_fields)
  end
end
