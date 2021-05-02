defmodule WarBoy.BasicWebsiteServer do
  use Plug.Router
  alias WarBoy.BasicWebsiteServer

  plug(:match)
  plug(:dispatch)

  get "/pages/1" do
    send_resp(conn, 200, "Page 1")
  end

  get "/pages/2" do
    send_resp(conn, 200, "Page 2")
  end

  @doc false
  def start_link(_) do
    portno =
      :war_boy
      |> Application.get_env(WarBoy.BasicWebsiteServer, portno: 21584)
      |> Keyword.fetch!(:portno)

    Plug.Cowboy.http(BasicWebsiteServer, [], port: portno)
  end

  @doc false
  def child_spec(opts) do
    %{
      id: BasicWebsiteServer,
      start: {BasicWebsiteServer, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
