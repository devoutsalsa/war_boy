defmodule WarBoy.BasicWebsite.AppServer do
  use Plug.Router
  alias WarBoy.BasicWebsite.AppServer
  alias WarBoy.BasicWebsite.SiteCounter

  plug(:match)
  plug(:dispatch)

  get "/counters/:id" do
    count = conn.params["id"] |> SiteCounter.increment() |> Integer.to_string()
    send_resp(conn, 200, "Count " <> count)
  end

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
      |> Application.get_env(AppServer, portno: 21584)
      |> Keyword.fetch!(:portno)

    Plug.Cowboy.http(AppServer, [], port: portno)
  end

  @doc false
  def child_spec(opts) do
    %{
      id: AppServer,
      start: {AppServer, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
