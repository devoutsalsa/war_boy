defmodule WarBoy.BasicWebsite.AppServer do
  use Plug.Router
  alias WarBoy.BasicWebsite.AppServer
  alias WarBoy.BasicWebsite.SiteCounter

  plug(:match)
  plug(:dispatch)

  get "/counters/:id" do
    count = conn.params["id"] |> SiteCounter.increment() |> Integer.to_string()
    template = basic_template("Count " <> count)
    send_resp(conn, 200, template)
  end

  get "/pages/1" do
    template = basic_template("Page 1")
    send_resp(conn, 200, template)
  end

  get "/pages/2" do
    template = basic_template("Page 2")
    send_resp(conn, 200, template)
  end

  get "/parents/1" do
    template = parent_template("Parent 1", "/children/1")
    send_resp(conn, 200, template)
  end

  get "/children/1" do
    template = basic_template("Child 1")
    send_resp(conn, 200, template)
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

  defp basic_template(str) do
    """
    <!doctype html>
    <html>
      <head>
        <title>
          BasicWebsite: #{str}
        </title>
      </head>
      <body>
        <h1>
          #{str}
        </h1>
      </body>
    </html>
    """
  end

  defp parent_template(str, child_url) do
    """
    <!doctype html>
    <html>
      <head>
        <title>
          BasicWebsite: #{str}
        </title>
      </head>
      <body>
        <h1>
          #{str}
        </h1>
        <div>
          <iframe id="child" src="#{child_url}">
        </div>
      </body>
    </html>
    """
  end
end
