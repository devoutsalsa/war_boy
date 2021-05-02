defmodule WarBoy.BasicWebsite.SiteCounter do
  use Agent

  alias WarBoy.BasicWebsite.SiteCounter

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: SiteCounter)
  end

  def count(anything) do
    func = fn state ->
      count = Map.get(state, anything, 0)
      {count, Map.put(state, anything, count)}
    end

    Agent.get_and_update(SiteCounter, func)
  end

  def increment(anything) do
    func = fn state ->
      count = Map.get(state, anything, 0) + 1
      {count, Map.put(state, anything, count)}
    end

    Agent.get_and_update(SiteCounter, func)
  end
end
