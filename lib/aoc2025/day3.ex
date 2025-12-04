defmodule Aoc2025.Day3 do
  def example do
    """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """
  end

  def part1(input_string) do
    input_string
    |> parse()
    |> Enum.map(&find_n_max(&1, 2))
    |> Enum.sum()
  end

  def part2(input_string) do
    input_string
    |> parse()
    |> Enum.map(&find_n_max(&1, 12))
    |> Enum.sum()
  end

  defp find_n_max(line, n) do
    reversed = Enum.reverse(line)

    Enum.reduce(2..n, cummax(reversed), fn i, prev ->
      m = :math.pow(10, i - 1) |> round()

      reversed
      |> Enum.drop(i - 1)
      |> Enum.zip(prev)
      |> Enum.map_reduce(-1, fn {x, prev_max}, cur_max ->
        Tuple.duplicate(max(x * m + prev_max, cur_max), 2)
      end)
      |> elem(0)
    end)
    |> Enum.max()
  end

  defp cummax([first | rest]) do
    {maxes, _} = Enum.map_reduce(rest, first, fn a, b -> {max(a, b), max(a, b)} end)
    [first | maxes]
  end

  defp parse(input_string) do
    input_string
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s -> String.to_charlist(s) |> Enum.map(&(&1 - ?0)) end)
  end
end
