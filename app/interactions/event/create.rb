class Event::Create < BaseInteraction
  attr_reader :event

  def call
    create_event!

    event
  end

  private

  def create_event!
    @event = Event.create!(event_params)
  end

  def event_params
    {
      eventable: params[:eventable],
      author: params[:user],
      description: params[:description],
      target: params[:target]
    }
  end
end

