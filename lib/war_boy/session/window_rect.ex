defmodule WarBoy.Session.WindowRect do
  alias WarBoy.Session.WindowRect
  defstruct height: 0, width: 0, x: 0, y: 0

  def create_or_update(nil, attrs) do
    create_or_update(%WindowRect{}, attrs)
  end

  def create_or_update(window_rect, attrs) do
    %WindowRect{
      height: Map.get(attrs, "height") || Map.get(attrs, :height) || window_rect.height,
      width: Map.get(attrs, "width") || Map.get(attrs, :width) || window_rect.width,
      x: Map.get(attrs, "x") || Map.get(attrs, :x) || window_rect.x,
      y: Map.get(attrs, "y") || Map.get(attrs, :y) || window_rect.y
    }
  end
end

defimpl Jason.Encoder, for: WarBoy.Session.WindowRect do
  alias Jason.Encode

  def encode(window_rect, opts \\ []) do
    Encode.map(
      %{
        height: window_rect.height,
        width: window_rect.width,
        x: window_rect.x,
        y: window_rect.y
      },
      opts
    )
  end
end
