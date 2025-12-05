defmodule Aoc2025.Day5 do
  def example do
    """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """
  end

  def part1(input_string) do
    {ranges, ids} = input_string |> parse()
    ranges = normalize_ranges(ranges)
    Enum.count(ids, &Enum.any?(ranges, fn r -> &1 in r end))
  end

  def part2(input_string) do
    input_string
    |> parse()
    |> elem(0)
    |> normalize_ranges()
    |> Enum.sum_by(&(&1.last - &1.first + 1))
  end

  defp normalize_ranges(ranges) do
    ranges
    |> Enum.sort_by(& &1.first)
    |> normalize_ranges([])
  end

  defp normalize_ranges([x], acc), do: Enum.reverse([x | acc])

  defp normalize_ranges([a, b | rest], acc) do
    cond do
      a.last < b.first -> normalize_ranges([b | rest], [a | acc])
      b.last > a.last -> normalize_ranges([a.first..b.last | rest], acc)
      true -> normalize_ranges([a | rest], acc)
    end
  end

  defp parse(input_string) do
    [ranges, ids] = input_string |> String.trim() |> String.split("\n\n")

    ranges =
      for line <- ranges |> String.split("\n") do
        [a, b] = for x <- String.split(line, "-"), do: String.to_integer(x)
        a..b
      end

    ids = for line <- String.split(ids, "\n"), do: String.to_integer(line)
    {ranges, ids}
  end
end
