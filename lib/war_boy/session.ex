defmodule WarBoy.Session do
  alias WarBoy.Session

  defstruct id: nil,
            capabilities: nil,
            timeouts: nil

  def new(attrs) do
    %Session{
      id: attrs["sessionId"],
      capabilities: attrs["capabilities"]
    }
  end

  def update!(session, attrs) do
    struct!(session, attrs)
  end
end
