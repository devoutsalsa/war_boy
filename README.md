# WarBoy

<a href="https://www.youtube.com/watch?v=mhm-4kDBhio">
  <img src="images/mad_max_fury_road_shiny_and_chrome.png">
</a>

*"~~Ride~~ Test eternal, shiny ~~&~~ w/ ~~chrome~~ Chrome." -- Immortan Joe, Elixir Developer*

WarBoy is an Elixir wrapper for [ChromeDriver](https://chromedriver.chromium.org/).  This is a work in progress, so if you're looking for something more mature, maybe check out [Wallaby](https://github.com/elixir-wallaby/wallaby).

## Using On Unix Vs Non-Unix Operating Systems

- WarBoy will (attempt to) start ChromeDriver automatically on when a `:unix` OS (e.g. Linux, Mac OS) is detected
- On a non-`:unix` (e.g. Windows) OS, you'll need to start ChromeDriver manually

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `war_boy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:war_boy, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/war_boy](https://hexdocs.pm/war_boy).
