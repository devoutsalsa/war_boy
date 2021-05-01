defmodule WarBoy do
  @moduledoc """
  Documentation for `WarBoy`.
  """

  def get_status!() do
    HTTPoison.get!(__chrome_driver_uri__() <> "/status")
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
end
