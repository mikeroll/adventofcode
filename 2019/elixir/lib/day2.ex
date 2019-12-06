defmodule Day2 do
  use Challenge, day: 2
  @behaviour Challenge

  @impl Challenge
  def prepare_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Stream.map(&String.to_integer/1)
  end

  defp load_program(program) do
    program
    |> Stream.with_index()
    |> Stream.map(fn {val, idx} -> {idx, val} end)
    |> Map.new()
  end

  @doc ~S"""
  Walks the `mem` memory map starting at position `ip`,
  executing instructions until encountering the "halt" instruction.
  Returns the final memory state.

  ## Examples

      iex> Day2.step_until_halt(%{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}, 0)
      %{0 => 2, 1 => 0, 2 => 0, 3 => 0, 4 => 99}

      iex> Day2.step_until_halt(%{0 => 2, 1 => 3, 2 => 0, 3 => 3, 4 => 99}, 0)
      %{0 => 2, 1 => 3, 2 => 0, 3 => 6, 4 => 99}

      iex> Day2.step_until_halt(%{0 => 2, 1 => 4, 2 => 4, 3 => 5, 4 => 99, 5 => 0}, 0)
      %{0 => 2, 1 => 4, 2 => 4, 3 => 5, 4 => 99, 5 => 9801}

      iex> Day2.step_until_halt(%{0 => 1, 1 => 1, 2 => 1, 3 => 4, 4 => 99, 5 => 5, 6 => 6, 7 => 0, 8 => 99}, 0)
      %{0 => 30, 1 => 1, 2 => 1, 3 => 4, 4 => 2, 5 => 5, 6 => 6, 7 => 0, 8 => 99}

  """
  def step_until_halt(mem, ip \\ 0) do
    {a, b, out_ptr} = {mem[mem[ip + 1]], mem[mem[ip + 2]], mem[ip + 3]}

    case mem[ip] do
      1 ->
        step_until_halt(%{mem | out_ptr => a + b}, ip + 4)

      2 ->
        step_until_halt(%{mem | out_ptr => a * b}, ip + 4)

      99 ->
        mem
    end
  end

  @doc ~S"""
  Executes the given `program` against `{verb, noun}` input,
  returning the final value at position `0`.

  ## Examples

      iex> Day2.execute([1, 42, 7, 4, 99, 5, 6, 0, 99], {1, 1})
      30

  """
  def execute(program, {verb, noun}) do
    load_program(program)
    |> Map.merge(%{1 => verb, 2 => noun})
    |> step_until_halt()
    |> Map.get(0)
  end

  @impl Challenge
  def solve(input) do
    part1 = execute(input, {12, 2})

    {verb, noun} =
      for(v <- 0..99, n <- 0..99, do: {v, n})
      |> Enum.find(fn {v, n} -> execute(input, {v, n}) == 19_690_720 end)

    part2 = verb * 100 + noun

    {part1, part2}
  end
end
