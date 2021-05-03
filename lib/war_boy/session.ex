defmodule WarBoy.Session do
  alias WarBoy.Session
  alias WarBoy.Session.Element
  alias WarBoy.Session.Timeouts
  alias WarBoy.Session.Window
  alias WarBoy.Session.WindowRect

  defstruct id: nil,
            capabilities: nil,
            timeouts: nil,
            deleted?: false,
            url: nil,
            title: nil,
            window: nil,
            window_handles: nil,
            element: nil,
            window_rect: nil

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

  def create_or_update_window!(session, window_attrs) do
    struct!(session, window: Window.create_or_update!(session.window, window_attrs))
  end

  def create_or_update_window_handles!(session, window_handles) do
    struct!(session, window_handles: window_handles)
  end

  def create_or_update_element!(session, element) do
    struct!(session, element: element)
  end

  def create_or_update_window_rect!(session, window_rect_attrs) do
    struct!(session,
      window_rect: WindowRect.create_or_update!(session.window_rect, window_rect_attrs)
    )
  end

  def delete!(session) do
    struct!(session, deleted?: true)
  end
end
