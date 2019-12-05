defmodule Challenge do
  defmacro __using__(day: day) do
    quote do
      def run do
        File.read!("input/day#{unquote(day)}.txt")
        |> prepare_input()
        |> solve()
        |> IO.inspect(label: "Day #{unquote(day)} solution")
      end
    end
  end

  @callback prepare_input(binary) :: any
  @callback solve(any) :: {any, any}
end
