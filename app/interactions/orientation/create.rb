class Orientation::Create < BaseInteraction
  attr_reader :orientation, :event

  def call
    create_orientation!
    create_orientation_event!

    orientation
  end

  private

  def create_orientation!
    @orientation = Orientation.create!(orientation_params.merge(relator_id: current_user.id))
  end

  def create_orientation_event!
    @event = Event::Create.call({eventable: occurrency, user: current_user, description: description, target: occurrency.responsible})
  end

  def occurrency_params
    params.slice(
      :title, :description, :kind, :area, :severity, :status, :student_id, :responsible_id
    )
  end

  def description
    "Uma orientação foi atribuida a #{orientation.responsible.name} por #{orientation.relator.name}"
  end
end

