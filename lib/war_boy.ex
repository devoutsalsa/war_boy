defmodule WarBoy do
  @moduledoc """
  Documentation for `WarBoy`.
  """

  alias WarBoy.Session

  def post_session!(attrs \\ __post_session_attrs__()) do
    "/session"
    |> post!(attrs)
    |> Session.new()
  end

  def delete_session!(session) do
    delete!("/session/" <> session.id)
  end

  def get_status!() do
    get!("/status")
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

  defp post!(path, body) do
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
