defmodule WarBoy.Session.WindowRect do
  alias WarBoy.Session.WindowRect
  defstruct height: 0, width: 0, x: 0, y: 0

  def create_or_update!(nil, window_rect_attrs) do
    create_or_update!(%WindowRect{}, window_rect_attrs)
  end

  def create_or_update!(window_rect, window_rect_attrs) do
    %WindowRect{
      height:
        Map.get(window_rect_attrs, "height") || Map.get(window_rect_attrs, :height) ||
          window_rect.height,
      width:
        Map.get(window_rect_attrs, "width") || Map.get(window_rect_attrs, :width) ||
          window_rect.width,
      x: Map.get(window_rect_attrs, "x") || Map.get(window_rect_attrs, :x) || window_rect.x,
      y: Map.get(window_rect_attrs, "y") || Map.get(window_rect_attrs, :y) || window_rect.y
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
