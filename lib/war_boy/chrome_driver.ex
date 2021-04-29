defmodule WarBoy.ChromeDriver do
  use GenServer
  alias WarBoy.ChromeDriver
  require Logger

  def start_link(_) do
    GenServer.start_link(ChromeDriver, [], name: ChromeDriver)
  end

  def init(_) do
    wrapper_path = "bin/wrapper.sh"
    chrome_driver_path = System.find_executable("chromedriver")

    portno =
      :war_boy
      |> Application.get_env(ChromeDriver, [])
      |> Keyword.get(:portno, 9515)
      |> Integer.to_string()

    port =
      Port.open({:spawn_executable, wrapper_path}, [
        :binary,
        :exit_status,
        args: [chrome_driver_path, "--port=#{portno}"]
      ])

    state = %{
      port: port,
      portno: portno,
      wrapper_path: wrapper_path,
      chrome_driver_path: chrome_driver_path
    }

    {:ok, state}
  end

  def handle_info({port, {:data, msg}}, %{port: port} = state) do
    Logger.info(msg)
    {:noreply, state}
  end

  def handle_info({port, {:exit_status, exit_code}}, %{port: port} = state) do
    msg = "ChromeDriver exited with exit_status #{exit_code}"
    if exit_code == 0, do: Logger.info(msg), else: Logger.warn(msg)
    {:noreply, state}
  end
end
