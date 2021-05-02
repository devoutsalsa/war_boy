defmodule WarBoy.Session do
  alias WarBoy.Session
  alias WarBoy.Session.Timeouts

  defstruct id: nil,
            capabilities: nil,
            timeouts: nil,
            deleted?: false,
            url: nil,
            title: nil,
            window: nil

  def new(attrs) do
    capabilities = Map.fetch!(attrs, "capabilities")
    timeouts = Timeouts.new!(Map.fetch!(capabilities, "timeouts"))

    %Session{
      id: Map.fetch!(attrs, "sessionId"),
      capabilities: capabilities,
      timeouts: timeouts
    }
  end

  def new_timeouts!(session, timeouts) do
    struct!(session, timeouts: Timeouts.new!(timeouts))
  end

  def update_timeouts!(session, timeouts) do
    struct!(session, timeouts: timeouts)
  end

  def update_url!(session, url) do
    struct!(session, url: url)
  end

  def update_title!(session, title) do
    struct!(session, title: title)
  end

  def update_window!(session, window) do
    struct!(session, window: window)
  end

  def delete!(session) do
    struct!(session, deleted?: true)
  end
end
