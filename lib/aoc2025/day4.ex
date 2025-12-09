defmodule Aoc2025.Day4 do
  def example do
    """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """
  end

  def part1(input_string) do
    input_string
    |> parse()
    |> Nx.tensor()
    |> removable()
    |> Nx.sum()
  end

  def part2(input_string) do
    input_string
    |> parse()
    |> Nx.tensor()
    |> removable_iter(0)
  end

  defp removable(field) do
    field
    |> Nx.pad(0, [{1, 1, 0}, {1, 1, 0}])
    |> Nx.window_sum({3, 3})
    |> Nx.less_equal(4)
    |> Nx.multiply(field)
  end

  defp removable_iter(field, removed_total) do
    boxes_to_remove = removable(field)
    removed_now = Nx.sum(boxes_to_remove) |> Nx.to_number()

    if removed_now == 0 do
      removed_total
    else
      field
      |> Nx.subtract(boxes_to_remove)
      |> removable_iter(removed_total + removed_now)
    end
  end

  defp parse(input_string) do
    input_string
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.to_charlist()
      |> Enum.map(fn
        ?@ -> 1
        ?. -> 0
      end)
    end)
  end
end
