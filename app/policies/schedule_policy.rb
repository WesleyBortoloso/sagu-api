class SchedulePolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def resolve
    return parent_scope     if user.is_a?(Parent)
    return teacher_scope    if user.is_a?(Teacher)
    return staff_scope      if user.is_a?(Staff)
    return manager_scope    if user.is_a?(Staff) && user.role_manager?

    Schedule.none
  end

  private

  def teacher_scope
    Schedule.where(relator_id: user.id)
  end

  def manager_scope
    Schedule.all
  end

  def staff_scope
    Schedule.where(relator_id: user.id)
  end

  def parent_scope
    Schedule.where(parent_id: user.id)
  end
end
