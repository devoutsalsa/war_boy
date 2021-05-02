defmodule WarBoy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias WarBoy.BasicWebsite.AppServer
  alias WarBoy.BasicWebsite.SiteCounter
  alias WarBoy.ChromeDriver
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      SiteCounter,
      AppServer
    ]

    children =
      if start_chrome_driver?() do
        children ++ [ChromeDriver]
      else
        Logger.warn("Non-unix OS detected.  ChromeDriver must be started manually.")
        children
      end

    opts = [strategy: :one_for_one, name: WarBoy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_chrome_driver?() do
    match?({:unix, _}, :os.type()) and Application.get_env(:warboy, :start_chrome_driver?, true)
  end
end
