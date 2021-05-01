defmodule WarBoyTest do
  use ExUnit.Case, async: false

  setup do
    on_exit(fn ->
      Application.put_env(
        :war_boy,
        :chrome_driver_scheme,
        WarBoy.__chrome_driver_scheme_default__()
      )

      Application.put_env(:war_boy, :chrome_driver_host, WarBoy.__chrome_driver_host_default__())

      Application.put_env(
        :war_boy,
        :chrome_driver_portno,
        WarBoy.__chrome_driver_portno_default__()
      )
    end)
  end

  describe "&get_status" do
    test "status" do
      %HTTPoison.Response{body: body, status_code: 200} = WarBoy.get_status!()

      assert "ChromeDriver ready for new sessions." ==
               body |> Jason.decode!() |> Map.fetch!("value") |> Map.fetch!("message")
    end
  end

  describe "&__chrome_driver_scheme__/0" do
    @tag default_scheme: :http
    test "default_scheme", %{default_scheme: default_scheme} do
      Application.delete_env(:war_boy, :chrome_driver_scheme)
      assert WarBoy.__chrome_driver_scheme__() == default_scheme
    end

    @tag custom_scheme: :https
    test "custom_scheme", %{custom_scheme: custom_scheme} do
      Application.put_env(:war_boy, :chrome_driver_scheme, custom_scheme)
      assert WarBoy.__chrome_driver_scheme__() == custom_scheme
    end
  end

  describe "&__chrome_driver_host__/0" do
    @tag default_host: "localhost"
    test "default_host", %{default_host: default_host} do
      Application.delete_env(:war_boy, :chrome_driver_host)
      assert WarBoy.__chrome_driver_host__() == default_host
    end

    @tag custom_host: "example.dev"
    test "custom_host", %{custom_host: custom_host} do
      Application.put_env(:war_boy, :chrome_driver_host, custom_host)
      assert WarBoy.__chrome_driver_host__() == custom_host
    end
  end

  describe "&__chrome_driver_portno__/0" do
    @tag default_portno: 9515
    test "default protno", %{default_portno: default_portno} do
      Application.delete_env(:war_boy, :chrome_driver_portno)
      assert WarBoy.__chrome_driver_portno__() == default_portno
    end

    @tag custom_portno: 12345
    test "custom_portno", %{custom_portno: custom_portno} do
      Application.put_env(:war_boy, :chrome_driver_portno, custom_portno)
      assert WarBoy.__chrome_driver_portno__() == custom_portno
    end
  end

  describe "&__chrome_driver_uri__/0" do
    @tag default_uri: "http://localhost:9515"
    test "default_uri", %{default_uri: default_uri} do
      Application.delete_env(:war_boy, :chrome_driver_scheme)
      Application.delete_env(:war_boy, :chrome_driver_host)
      Application.delete_env(:war_boy, :chrome_driver_portno)
      assert WarBoy.__chrome_driver_uri__() == default_uri
    end
  end
end
