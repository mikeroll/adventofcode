defmodule Day1 do
  use Challenge, day: 1
  @behaviour Challenge

  @doc ~S"""
  Calculates fuel required for a module of `mass`.

  ## Examples:
      iex> Day1.net_fuel(12)
      2

      iex> Day1.net_fuel(14)
      2

      iex> Day1.net_fuel(1969)
      654

      iex> Day1.net_fuel(100756)
      33583
  """
  def net_fuel(mass), do: max(div(mass, 3) - 2, 0)

  @doc ~S"""
  Calculates fuel required for a module of `mass`, plus for the fuel itself.

  ## Examples
      iex> Day1.total_fuel(14)
      2

      iex> Day1.total_fuel(1969)
      966

      iex> Day1.total_fuel(100756)
      50346
  """
  def total_fuel(mass) when mass < 9, do: 0

  def total_fuel(mass) do
    fuel_so_far = net_fuel(mass)
    fuel_so_far + total_fuel(fuel_so_far)
  end

  @impl Challenge
  def prepare_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @impl Challenge
  def solve(input) do
    Enum.reduce(input, {0, 0}, fn m, {net, total} ->
      {net + net_fuel(m), total + total_fuel(m)}
    end)
  end
end
