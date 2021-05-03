defmodule WarBoy do
  @moduledoc """
  Documentation for `WarBoy`.
  """

  alias WarBoy.Session
  alias WarBoy.Session.Timeouts

  def post_session!(attrs \\ __post_session_attrs__()) do
    with attrs <- post!("/session", attrs) do
      Session.new(attrs)
    end
  end

  def delete_session!(session) do
    with nil <- delete!("/session/" <> session.id) do
      Session.delete!(session)
    end
  end

  def get_status!() do
    get!("/status")
  end

  def get_timeouts!(session) do
    with timeouts <- get!("/session/" <> session.id <> "/timeouts") do
      Session.new_timeouts!(session, timeouts)
    end
  end

  def post_timeouts!(session, timeout_attrs) do
    with timeouts <- Timeouts.update!(session.timeouts, timeout_attrs),
         nil <- post!("/session/" <> session.id <> "/timeouts", timeouts) do
      Session.update_timeouts!(session, timeouts)
    end
  end

  def post_url!(session, url) do
    with chrome_driver_url <- "/session/" <> session.id <> "/url",
         url_attrs <- %{url: url},
         nil <- post!(chrome_driver_url, url_attrs) do
      Session.update_url!(session, url)
    end
  end

  def get_url!(session) do
    with url <- get!("/session/" <> session.id <> "/url") do
      Session.update_url!(session, url)
    end
  end

  def post_back!(session) do
    with nil <- post!("/session/" <> session.id <> "/back") do
      Session.update_url!(session, nil)
    end
  end

  def post_forward!(session) do
    with nil <- post!("/session/" <> session.id <> "/forward") do
      Session.update_url!(session, nil)
    end
  end

  def post_refresh!(session) do
    with nil <- post!("/session/" <> session.id <> "/refresh") do
      session
    end
  end

  def get_title!(session) do
    with title <- get!("/session/" <> session.id <> "/title") do
      Session.update_title!(session, title)
    end
  end

  def get_window!(session) do
    with window <- get!("/session/" <> session.id <> "/window") do
      Session.create_or_update_window!(session, window)
    end
  end

  def delete_window!(session) do
    case delete!("/session/" <> session.id <> "/window") do
      [] ->
        Session.delete!(session)
    end
  end

  def get_window_handles!(session) do
    with window_handles <- get!("/session/" <> session.id <> "/window/handles") do
      Session.create_or_update_window_handles!(session, window_handles)
    end
  end

  def post_new_window!(session) do
    with _ <- post!("/session/" <> session.id <> "/window/new") do
      session
    end
  end

  @doc false
  def __chrome_driver_scheme__() do
    Application.get_env(:war_boy, :chrome_driver_scheme, __chrome_driver_scheme_default__())
  end

  @doc false
  def __chrome_driver_scheme_default__() do
    :http
  end

  @doc false
  def __chrome_driver_portno__() do
    Application.get_env(:war_boy, :chrome_driver_portno, __chrome_driver_portno_default__())
  end

  @doc false
  def __chrome_driver_portno_default__() do
    9515
  end

  @doc false
  def __chrome_driver_host__() do
    Application.get_env(:war_boy, :chrome_driver_host, __chrome_driver_host_default__())
  end

  @doc false
  def __chrome_driver_host_default__() do
    "localhost"
  end

  @doc false
  def __chrome_driver_uri__() do
    Atom.to_string(__chrome_driver_scheme__()) <>
      "://" <> __chrome_driver_host__() <> ":" <> Integer.to_string(__chrome_driver_portno__())
  end

  @doc false
  def __post_session_attrs__() do
    %{
      capabilities: %{
        alwaysMatch: %{
          browserName: "chrome",
          "goog:chromeOptions": %{
            args: ["--headless"]
          }
        }
      }
    }
  end

  def uri(path) do
    __chrome_driver_uri__() <> path
  end

  defp delete!(path) do
    path
    |> uri()
    |> HTTPoison.delete!()
    |> handle_response!()
  end

  defp get!(path) do
    path
    |> uri()
    |> HTTPoison.get!()
    |> handle_response!()
  end

  defp post!(path, body \\ %{}) do
    path
    |> uri()
    |> HTTPoison.post!(Jason.encode!(body))
    |> handle_response!()
  end

  defp handle_response!(%HTTPoison.Response{body: body, status_code: 200}) do
    body
    |> Jason.decode!()
    |> Map.fetch!("value")
  end
end
