defmodule WarBoy.Session do
  alias WarBoy.Session

  defstruct id: nil,
            capabilities: nil,
            timeouts: nil,
            deleted?: false

  def new(attrs) do
    struct!(Session, id: attrs["sessionId"], capabilities: attrs["capabilities"])
  end

  def update!(session, attrs) do
    struct!(session, attrs)
  end

  def delete!(session) do
    struct!(session, deleted?: true)
  end
end
