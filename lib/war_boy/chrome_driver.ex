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

    portno = WarBoy.__chrome_driver_portno__()

    port =
      Port.open({:spawn_executable, wrapper_path}, [
        :binary,
        :exit_status,
        args: [chrome_driver_path, "--port=#{portno}"]
      ])

    :ok = get_chrome_driver_status!(port)

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

  defp get_chrome_driver_status!(port, countdown \\ 10)

  defp get_chrome_driver_status!(_, 0) do
    raise "Enable to start ChromeDriver"
  end

  defp get_chrome_driver_status!(port, countdown) do
    case HTTPoison.get(WarBoy.__chrome_driver_uri__() <> "/status") do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        msg =
          body
          |> Jason.decode!()
          |> Map.fetch!("value")
          |> Map.fetch!("message")

        send(self(), {port, {:data, msg}})
        :ok

      {:ok, error} ->
        Logger.error(inspect(error))
        :timer.sleep(1_000)
        get_chrome_driver_status!(port, countdown - 1)

      {:error, error} ->
        Logger.error(inspect(error))
        :timer.sleep(1_000)
        get_chrome_driver_status!(port, countdown - 1)
    end
  end
end
