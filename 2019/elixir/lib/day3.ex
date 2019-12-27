defmodule Day3 do
  use Challenge, day: 3
  @behaviour Challenge

  defp load_path(path) do
    path
    |> String.split(",", trim: true)
    |> Stream.map(&String.split_at(&1, 1))
    |> Stream.map(fn {dir, step} -> {dir, String.to_integer(step)} end)
  end

  @impl Challenge
  def prepare_input(binary) do
    binary
    |> String.split("\n", trim: true)
    |> Enum.map(&load_path/1)
  end

  @direction_vectors %{
    "U" => {0, 1},
    "D" => {0, -1},
    "R" => {1, 0},
    "L" => {-1, 0}
  }

  def segment_cells({dir, step}) do
    Stream.cycle([@direction_vectors[dir]])
    |> Stream.take(step)
  end

  def lay_wire(moves) do
    moves
    |> Stream.flat_map(&segment_cells/1)
    |> Stream.scan(fn {dx, dy}, {x, y} -> {x + dx, y + dy} end)
    |> Stream.with_index(1)
    |> Map.new()
  end

  def distance({x, y}), do: abs(x) + abs(y)

  @impl Challenge
  def solve(move_seqs) do
    wires = Enum.map(move_seqs, &lay_wire/1)

    intersections =
      wires
      |> Enum.map(&Map.keys/1)
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)

    closest_intersection_distance =
      intersections
      |> Enum.map(&distance/1)
      |> Enum.min()

    earliest_intersection_combined_steps =
      intersections
      |> Enum.map(fn point ->
        wires
        |> Enum.map(&Access.get(&1, point))
        |> Enum.reduce(&+/2)
      end)
      |> Enum.min()

    {closest_intersection_distance, earliest_intersection_combined_steps}
  end
end
