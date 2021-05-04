defmodule WarBoy.Session.Window do
  alias WarBoy.Session.Window
  defstruct handle: nil, type: nil

  def create_or_update(nil, handle) when is_binary(handle) do
    create_or_update(%Window{}, handle)
  end

  def create_or_update(window, handle) when is_binary(handle) do
    create_or_update(window, %{handle: handle})
  end

  def create_or_update(nil, attrs) do
    create_or_update(%Window{}, attrs)
  end

  def create_or_update(window, attrs) do
    %Window{
      handle: Map.get(attrs, "handle") || Map.get(attrs, :handle) || window.handle,
      type: Map.get(attrs, "type") || Map.get(attrs, :type) || window.type
    }
  end
end
