class Authorization::Create < BaseInteraction
  attr_reader :authorization, :event

  def call
    fetch_student!
    create_authorization!
    create_event!

    authorization
  end

  private

  def fetch_student!
    @student ||= Student.find(params[:student_id])
  rescue ActiveRecord::RecordNotFound
    error!({ error: "Student not found", detail: "ID #{params[:student_id]} is invalid" }, 404)
  end

  def create_authorization!
    @authorization = Authorization.create!(
      description: params[:description],
      status: params[:status],
      date: params[:date],
      student_id: student.id,
      parent_id: student.parent_id
    )
  end

  def create_event!
    return unless student.parent

    @event = Event::Create.call(
      {
        eventable: authorization,
        user: current_user,
        target: student.parent,
        description: event_description
      }
    )
  end

  def event_description
    "Uma nova autorização foi criado por #{current_user.name} para #{authorization.student.name}"
  end
end
