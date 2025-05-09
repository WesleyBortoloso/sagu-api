class Student::Update < BaseInteraction
  attr_reader :student

  def call
    find_student!
    update_student!

    student
  end

  private

  def find_student!
    @student = Student.find(params[:student_id])
  end

  def update_student!
    student.assign_attributes(
      email: params[:email],
      classroom_id: params[:classroom_id],
      phone: params[:phone]
    )
  
    student.situation = params[:situation] if params[:situation].present?
  
    student.save!
  end
end
