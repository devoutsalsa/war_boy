defmodule WarBoy.Session.Timeouts do
  alias WarBoy.Session.Timeouts
  defstruct implicit: nil, page_load: nil, script: nil

  def create_or_update(nil, attrs) do
    create_or_update(%Timeouts{}, attrs)
  end

  def create_or_update(timeouts, attrs) do
    %Timeouts{
      implicit: Map.get(attrs, "implicit") || Map.get(attrs, :implicit) || timeouts.implicit,
      page_load: Map.get(attrs, "pageLoad") || Map.get(attrs, :page_load) || timeouts.page_load,
      script: Map.get(attrs, "script") || Map.get(attrs, :script) || timeouts.script
    }
  end
end

defimpl Jason.Encoder, for: WarBoy.Session.Timeouts do
  alias Jason.Encode

  def encode(timeouts, opts \\ []) do
    Encode.map(
      %{
        "implicit" => timeouts.implicit,
        "pageLoad" => timeouts.page_load,
        "script" => timeouts.script
      },
      opts
    )
  end
end
