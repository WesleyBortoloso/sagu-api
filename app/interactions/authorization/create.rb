class Authorization::Create < BaseInteraction
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
      relator: params[:user],
      starts_at: params[:starts_at],
      subject: params[:subject],
      area: params[:area],
      status: params[:status]
    )
  end

  def create_event!
    Event.create!(
      eventable: schedule,
      author: params[:user],
      target: student.parent,
      description: "Uma nova autorização foi criada por #{current_user.name} para #{authorization.schedule.name}"
    )
  end
end
