class Student::Create < BaseInteraction
  attr_reader :student

  def call
    create_student!

    student
  end

  private

  def create_student!
    @student = Student.create!(student_params)
  end

  def student_params
    params
  end
end
