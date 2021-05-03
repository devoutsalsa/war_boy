defmodule WarBoy.Session.Element do
  alias WarBoy.Session.Element
  defstruct key: nil, value: nil

  def create_or_update!(nil, attrs) do
    create_or_update!(Element, attrs)
  end

  def create_or_update!(element, attrs) do
    [{key, value}] = Map.to_list(attrs)
    struct!(element, key: key, value: value)
  end
end
