defmodule WarBoy.Session do
  alias WarBoy.Session

  defstruct id: nil,
            capabilities: nil

  def new(attrs) do
    %Session{
      id: attrs["sessionId"],
      capabilities: attrs["capabilities"]
    }
  end
end
