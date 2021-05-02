defmodule WarBoy.Session.Timeouts do
  alias WarBoy.Session.Timeouts
  defstruct implicit: nil, page_load: nil, script: nil

  def new!(attrs) do
    %Timeouts{
      implicit: Map.fetch!(attrs, "implicit"),
      page_load: Map.fetch!(attrs, "pageLoad"),
      script: Map.fetch!(attrs, "script")
    }
  end

  def update!(timeouts, timeout_attrs) do
    struct!(timeouts, timeout_attrs)
  end
end

defimpl Jason.Encoder, for: WarBoy.Session.Timeouts do
  def encode(timeouts, opts \\ []) do
    Jason.Encode.map(
      %{
        "implicit" => timeouts.implicit,
        "pageLoad" => timeouts.page_load,
        "script" => timeouts.script
      },
      opts
    )
  end
end
