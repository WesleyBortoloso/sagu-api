class Orientation::Create < BaseInteraction
  attr_reader :orientation, :event, :student

  def call
    find_student!
    create_orientation!
    create_orientation_event!

    orientation
  end

  private

  def find_student!
    @student = Student.find(params[:student_id])
  end

  def create_orientation!
    @orientation = Orientation.create!(orientation_params.merge(relator_id: current_user.id, parent_id: student&.parent&.id))
  end

  def create_orientation_event!
    @event = Event::Create.call({eventable: orientation, user: current_user, description: description, target: orientation.responsible})
  end

  def orientation_params
    params.slice(
      :title, :description, :area, :status, :student_id, :responsible_id
    )
  end

  def description
    "Uma orientação foi atribuida a #{orientation.responsible.name} por #{orientation.relator.name}"
  end
end
