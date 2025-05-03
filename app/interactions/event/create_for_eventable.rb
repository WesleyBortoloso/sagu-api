class Event::CreateForEventable < BaseInteraction
  attr_reader :event

  def call
    resolve_eventable!
    create_event!

    event
  end

  private

  def create_event!
    @event = Event.create!(
      eventable: @eventable,
      author: params[:user],
      description: params[:description]
    )
  end

  def resolve_eventable!
    klass = params[:eventable_type].constantize
    @eventable = klass.find(params[:eventable_id])
  rescue NameError, ActiveRecord::RecordNotFound => e
    error!({ error: "Invalid eventable", detail: e.message }, 422)
  end
end

