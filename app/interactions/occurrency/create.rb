class Occurrency::Create < BaseInteraction
  attr_reader :occurrency, :event

  def call
    create_occurrency!
    create_occurrency_event!

    occurrency
  end

  private

  def create_occurrency!
    @occurrency = Occurrency.create!(occurrency_params.merge(relator_id: current_user.id))
  end

  def create_occurrency_event!
    @event = Event::Create.call({eventable: occurrency, user: current_user, description: description})
  end

  def occurrency_params
    params.slice(
      :title, :description, :kind, :area, :severity, :status, :student_id, :responsible_id
    )
  end

  def description
    "Uma ocorrência foi atribuida a #{occurrency.responsible.name} por #{occurrency.relator.name}"
  end
end

