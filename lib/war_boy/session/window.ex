defmodule WarBoy.Session.Window do
  alias WarBoy.Session.Window
  defstruct [handle: nil, type: nil]

  def create_or_update!(nil, handle) when is_binary(handle) do
    create_or_update!(Window, handle)
  end

  def create_or_update!(window, handle) when is_binary(handle) do
    struct!(window, handle: handle)
  end
end
