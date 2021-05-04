defmodule WarBoy do
  @moduledoc """
  Documentation for `WarBoy`.
  """

  alias WarBoy.Session
  alias WarBoy.Session.Timeouts
  alias WarBoy.Session.WindowRect

  def post_session!(attrs \\ __post_session_attrs__()) do
    "/session"
    |> post!(attrs)
    |> Session.new!()
  end

  def delete_session!(session) do
    path = "/session/" <> session.id

    path
    |> delete!()
    |> case do
      nil ->
        Session.delete!(session)
    end
  end

  def get_status!() do
    get!("/status")
  end

  def get_timeouts!(session) do
    path = "/session/" <> session.id <> "/timeouts"

    path
    |> get!()
    |> case do
      timeouts ->
        Session.new_timeouts!(session, timeouts)
    end
  end

  def post_timeouts!(session, timeout_attrs) do
    path = "/session/" <> session.id <> "/timeouts"
    timeouts = Timeouts.create_or_update(session.timeouts, timeout_attrs)

    path
    |> post!(timeouts)
    |> case do
      nil ->
        Session.update_timeouts!(session, timeouts)
    end
  end

  def post_url!(session, url) do
    path = "/session/" <> session.id <> "/url"
    attrs = %{url: url}

    path
    |> post!(attrs)
    |> case do
      nil ->
        Session.update_url!(session, url)
    end
  end

  def get_url!(session) do
    path = "/session/" <> session.id <> "/url"

    path
    |> get!()
    |> case do
      url ->
        Session.update_url!(session, url)
    end
  end

  def post_back!(session) do
    path = "/session/" <> session.id <> "/back"

    path
    |> post!()
    |> case do
      nil ->
        Session.update_url!(session, nil)
    end
  end

  def post_forward!(session) do
    path = "/session/" <> session.id <> "/forward"

    path
    |> post!()
    |> case do
      nil ->
        Session.update_url!(session, nil)
    end
  end

  def post_refresh!(session) do
    path = "/session/" <> session.id <> "/refresh"

    path
    |> post!()
    |> case do
      nil ->
        session
    end
  end

  def get_title!(session) do
    path = "/session/" <> session.id <> "/title"

    path
    |> get!()
    |> case do
      title ->
        Session.update_title!(session, title)
    end
  end

  def get_window!(session) do
    path = "/session/" <> session.id <> "/window"

    path
    |> get!()
    |> case do
      window ->
        Session.create_or_update_window!(session, window)
    end
  end

  def delete_window!(session) do
    path = "/session/" <> session.id <> "/window"

    path
    |> delete!()
    |> case do
      [] ->
        Session.delete!(session)

      window_handles ->
        Session.create_or_update_window_handles!(session, window_handles)
    end
  end

  def post_window!(session, handle) do
    path = "/session/" <> session.id <> "/window"
    attrs = %{handle: handle}

    path
    |> post!(attrs)
    |> case do
      nil ->
        session
    end
  end

  def get_window_handles!(session) do
    path = "/session/" <> session.id <> "/window/handles"

    path
    |> get!()
    |> case do
      window_handles ->
        Session.create_or_update_window_handles!(session, window_handles)
    end
  end

  def post_window_new!(session) do
    path = "/session/" <> session.id <> "/window/new"

    path
    |> post!()
    |> case do
      window ->
        Session.create_or_update_window!(session, window)
    end
  end

  def post_frame!(session, id) do
    path = "/session/" <> session.id <> "/frame"
    attrs = %{id: id}

    path
    |> post!(attrs)
    |> case do
      nil ->
        session
    end
  end

  def post_frame_parent!(session) do
    path = "/session/" <> session.id <> "/frame/parent"

    path
    |> post!()
    |> case do
      nil ->
        session
    end
  end

  def get_window_rect!(session) do
    path = "/session/" <> session.id <> "/window/rect"

    path
    |> get!()
    |> case do
      attrs ->
        Session.create_or_update_window_rect!(session, attrs)
    end
  end

  def post_window_rect!(session, attrs) do
    path = "/session/" <> session.id <> "/window/rect"
    attrs = WindowRect.create_or_update(session.window_rect, attrs)

    path
    |> post!(attrs)
    |> case do
      attrs ->
        Session.create_or_update_window_rect!(session, attrs)
    end
  end

  def post_window_maximize!(session) do
    path = "/session/" <> session.id <> "/window/maximize"

    path
    |> post!()
    |> case do
      attrs ->
        Session.create_or_update_window_rect!(session, attrs)
    end
  end

  def post_window_minimize!(session) do
    path = "/session/" <> session.id <> "/window/minimize"

    path
    |> post!()
    |> case do
      attrs ->
        Session.create_or_update_window_rect!(session, attrs)
    end
  end

  def post_window_fullscreen!(session) do
    path = "/session/" <> session.id <> "/window/minimize"

    path
    |> post!()
    |> case do
      attrs ->
        Session.create_or_update_window_rect!(session, attrs)
    end
  end

  def get_element_active!(session) do
    path = "/session/" <> session.id <> "/element/active"

    path
    |> get!()
    |> case do
      element ->
        Session.create_or_update_element!(session, element)
    end
  end

  def post_element!(session, using, value) do
    path = "/session/" <> session.id <> "/element"
    attrs = %{using: using, value: value}

    path
    |> post!(attrs)
    |> case do
      element ->
        Session.create_or_update_element!(session, element)
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
            args: [
              "--headless",
              "--start-maximized"
            ]
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
