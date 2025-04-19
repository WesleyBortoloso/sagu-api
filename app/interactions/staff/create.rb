class Staff::Create < BaseInteraction
  attr_reader :staff

  def call
    create_staff!

    staff
  end

  private

  def create_staff!
    @staff = Staff.create!(staff_params)
  end

  def staff_params
    params
  end
end
