class V1::Dashboard < Grape::API
  include UserAuthenticated

  resource :dashboard do
    desc 'Return global statistics for dashboard'
    get :stats do
      {
        total_students: Student.count,
        scheduled_appointments: Schedule.where(relator: current_user).where('starts_at >= ?', Time.zone.now).count,
        pending_occurrencies: Occurrency.where(responsible: current_user, status: :open).count,
        pending_orientations: Orientation.where(responsible: current_user, status: :pending).count
      }
    end
  end
end
