defmodule Day4 do
  use Challenge, day: 4
  @behaviour Challenge

  @impl Challenge
  def prepare_input(binary) do
    binary
    |> String.trim_trailing()
    |> String.split("-", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc ~S"""
  Given a six-digit numeric password, generate the next one satisfying these
  criteria:
    - New password > old password numerically
    - Going from left to right, the digits never decrease; they only ever
    increase or stay the same (like 111123 or 135679).

  Examples:

      iex> Day4.next_password(183564)
      188888

      iex> Day4.next_password(188888)
      188889

      iex> Day4.next_password(188889)
      188899

      iex> Day4.next_password(657474)
      666666

  """
  def next_password(password) do
    {next_number, _} =
      (password + 1)
      |> Integer.digits()
      |> Enum.map_reduce(
        {0, :rising},
        fn
          x, {pivot, :rising} when x >= pivot -> {x, {x, :rising}}
          _, {pivot, _} -> {pivot, {pivot, :plateau}}
        end
      )

    Integer.undigits(next_number)
  end

  def generate_passwords(lower, upper) do
    Stream.unfold(lower, fn x ->
      p = next_password(x)
      {p, p}
    end)
    |> Stream.take_while(&(&1 <= upper))
  end

  @doc ~S"""
  Returns `true` if a password has any number of repeating digits.

      iex> Day4.has_repeating_digits(143521)
      false

      iex> Day4.has_repeating_digits(141551)
      true

  """
  def has_repeating_digits(password) do
    digits = Integer.digits(password)
    Enum.dedup(digits) != digits
  end

  @doc ~S"""
  Returns `true` if a password has a group of exactly `n` repeating digits.

      iex> Day4.has_isolated_digit_groups(123444, 2)
      false

      iex> Day4.has_isolated_digit_groups(112233, 2)
      true

  """
  def has_isolated_digit_groups(password, n) do
    Integer.digits(password)
    |> Enum.chunk_by(& &1)
    |> Enum.any?(&(Enum.count(&1) == n))
  end

  @impl Challenge
  def solve([lower, upper]) do
    passwords = generate_passwords(lower, upper)

    {
      Enum.count(passwords, &has_repeating_digits/1),
      Enum.count(passwords, &has_isolated_digit_groups(&1, 2))
    }
  end
end
