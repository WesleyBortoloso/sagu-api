class Schedule::Create < BaseInteraction
  attr_reader :schedule, :student

  def call
    fetch_student!
    create_schedule!
    create_event!

    schedule
  end

  private

  def fetch_student!
    @student = Student.find(params[:student_id])
  rescue ActiveRecord::RecordNotFound
    error!({ error: "Student not found", detail: "ID #{params[:student_id]} is invalid" }, 404)
  end

  def create_schedule!
    @schedule = Schedule.create!(
      student: student,
      parent: student.parent,
      relator: current_user,
      starts_at: params[:starts_at],
      subject: params[:subject],
      area: params[:area],
      status: params[:status]
    )
  end

  def create_event!
    @event = Event::Create.call({eventable: schedule, user: current_user, description: event_description, target: schedule.parent})
  end

  def event_description
    "Um novo agendamento foi criado por #{schedule.relator.name} para #{schedule.parent.name}"
  end
end
