defmodule WarBoyTest do
  use ExUnit.Case, async: false

  alias WarBoy.Session

  describe "configuration" do
    setup do
      on_exit(fn ->
        Application.put_env(
          :war_boy,
          :chrome_driver_scheme,
          WarBoy.__chrome_driver_scheme_default__()
        )

        Application.put_env(
          :war_boy,
          :chrome_driver_host,
          WarBoy.__chrome_driver_host_default__()
        )

        Application.put_env(
          :war_boy,
          :chrome_driver_portno,
          WarBoy.__chrome_driver_portno_default__()
        )
      end)
    end

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

    @tag default_uri: "http://localhost:9515"
    test "default_uri", %{default_uri: default_uri} do
      Application.delete_env(:war_boy, :chrome_driver_scheme)
      Application.delete_env(:war_boy, :chrome_driver_host)
      Application.delete_env(:war_boy, :chrome_driver_portno)
      assert WarBoy.__chrome_driver_uri__() == default_uri
    end
  end

  describe "sessions" do
    setup(:session_setup_and_teardown)

    test "POST /sessions", %{session: session} do
      assert match?(%Session{}, session)
    end

    test "DELETE /sessions/:id", %{session: session} do
      session = WarBoy.delete_session!(session)
      assert match?(%Session{}, session)
      assert session.deleted? == true
    end
  end

  describe "status" do
    setup(:session_setup_and_teardown)

    test "GET /status" do
      assert "ChromeDriver ready for new sessions." ==
               WarBoy.get_status!() |> Map.fetch!("message")
    end
  end

  describe "timeouts" do
    setup(:session_setup_and_teardown)

    test "GET /sessions/:id/timeouts", %{session: session} do
      session = WarBoy.get_timeouts!(session)
      assert match?(%Session{}, session)
      assert match?(%{implicit: _, page_load: _, script: _}, session.timeouts)
    end

    test "POST /sessions/:id/timeouts", %{session: session} do
      timeouts = session.timeouts

      timeout_attrs = %{
        implicit: timeouts.implicit + 1,
        page_load: timeouts.page_load + 1,
        script: timeouts.script + 1
      }

      session = WarBoy.post_timeouts!(session, timeout_attrs)
      assert match?(%Session{}, session)
      timeouts = WarBoy.get_timeouts!(session).timeouts
      assert timeouts.implicit == timeout_attrs.implicit
      assert timeouts.page_load == timeout_attrs.page_load
      assert timeouts.script == timeout_attrs.script
    end
  end

  defp session_setup_and_teardown(context) do
    session = WarBoy.post_session!()
    on_exit(fn -> WarBoy.delete_session!(session) end)
    Map.put(context, :session, session)
  end
end
