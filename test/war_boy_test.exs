defmodule WarBoyTest do
  use ExUnit.Case, async: false

  alias WarBoy.Session
  alias WarBoy.BasicWebsite.SiteCounter

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

    test "POST /session", %{session: session} do
      assert match?(%Session{}, session)
    end

    test "DELETE /session/:id", %{session: session} do
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

    test "GET /session/:id/timeouts", %{session: session} do
      session = WarBoy.get_timeouts!(session)
      assert match?(%Session{}, session)
      assert match?(%{implicit: _, page_load: _, script: _}, session.timeouts)
    end

    test "POST /session/:id/timeouts", %{session: session} do
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

  describe "navigation" do
    setup(:session_setup_and_teardown)

    @tag url: "http://localhost:21584/pages/1"
    test "POST /session/:id/url", %{session: session, url: url} do
      session = WarBoy.post_url!(session, url)
      assert match?(%Session{}, session)
      assert session.url == url
    end

    @tag url: "http://localhost:21584/pages/1"
    test "GET /session/:id/url", %{session: session, url: url} do
      session = WarBoy.post_url!(session, url)
      session = WarBoy.get_url!(session)
      assert match?(%Session{}, session)
      assert session.url == url
    end

    @tag url_1: "http://localhost:21584/pages/1"
    @tag url_2: "http://localhost:21584/pages/2"
    test "POST /session/:id/back", %{session: session, url_1: url_1, url_2: url_2} do
      session = WarBoy.post_url!(session, url_1)
      session = WarBoy.get_url!(session)
      assert session.url == url_1
      session = WarBoy.post_url!(session, url_2)
      session = WarBoy.get_url!(session)
      assert session.url == url_2
      session = WarBoy.post_back!(session)
      assert match?(%Session{}, session)
      session = WarBoy.get_url!(session)
      assert session.url == url_1
    end

    @tag url_1: "http://localhost:21584/pages/1"
    @tag url_2: "http://localhost:21584/pages/2"
    test "POST /session/:id/forward", %{session: session, url_1: url_1, url_2: url_2} do
      session = WarBoy.post_url!(session, url_1)
      session = WarBoy.get_url!(session)
      assert session.url == url_1
      session = WarBoy.post_url!(session, url_2)
      session = WarBoy.get_url!(session)
      assert session.url == url_2
      session = WarBoy.post_back!(session)
      session = WarBoy.get_url!(session)
      assert session.url == url_1
      session = WarBoy.post_forward!(session)
      assert match?(%Session{}, session)
      session = WarBoy.get_url!(session)
      assert session.url == url_2
    end

    @tag id: "95253c6a-a05a-40bc-99c2-7ef5c9240c23"
    @tag url: "http://localhost:21584/counters/95253c6a-a05a-40bc-99c2-7ef5c9240c23"
    test "POST /session/:id/refresh", %{session: session, id: id, url: url} do
      assert SiteCounter.count(id) == 0
      session = WarBoy.post_url!(session, url)
      assert SiteCounter.count(id) == 1
      session = WarBoy.post_refresh!(session)
      assert match?(%Session{}, session)
      assert SiteCounter.count(id) == 2
      _session = WarBoy.post_refresh!(session)
      assert SiteCounter.count(id) == 3
    end

    @tag url: "http://localhost:21584/pages/1"
    @tag title: "BasicWebsite: Page 1"
    test "GET /session/:id/title", %{session: session, url: url, title: title} do
      session = WarBoy.post_url!(session, url)
      session = WarBoy.get_title!(session)
      assert match?(%Session{}, session)
      assert session.title == title
    end
  end

  describe "contexts" do
    setup(:session_setup_and_teardown)

    @tag url: "http://localhost:21584/pages/1"
    test "GET /session/:id/window", %{session: session, url: url} do
      session = WarBoy.post_url!(session, url)
      session = WarBoy.get_window!(session)
      assert match?(%Session{}, session)
      assert is_binary(session.window)
    end
  end

  defp session_setup_and_teardown(context) do
    session = WarBoy.post_session!()
    on_exit(fn -> WarBoy.delete_session!(session) end)
    Map.put(context, :session, session)
  end
end
