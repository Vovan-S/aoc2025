defmodule Aoc2025.Day7 do
  def example do
    """
    .......S.......
    ...............
    .......^.......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............
    """
  end

  def part1(input_string) do
    {start_pos, splitter_lines} = input_string |> parse()
    simulate_all(start_pos, splitter_lines) |> elem(1)
  end

  def part2(input_string) do
    {start_pos, splitter_lines} = input_string |> parse()

    simulate_all(start_pos, splitter_lines)
    |> elem(0)
    |> Enum.sum_by(&elem(&1, 1))
  end

  defp simulate_all(start_pos, splitter_lines) do
    Enum.reduce(splitter_lines, {[{start_pos, 1}], 0}, fn line, {beams, n} ->
      {new_beams, new_splits} = process_beams(beams, line)
      {new_beams, new_splits + n}
    end)
  end

  defp process_beams(beams, []), do: {beams, 0}

  defp process_beams(beams, splitters) do
    splitters = MapSet.new(splitters)

    {new_beams, n_splits} =
      Enum.flat_map_reduce(beams, 0, fn {i, n_paths}, n_splits ->
        if MapSet.member?(splitters, i) do
          {[{i - 1, n_paths}, {i + 1, n_paths}], n_splits + 1}
        else
          {[{i, n_paths}], n_splits}
        end
      end)

    {aggregate_beams(new_beams), n_splits}
  end

  defp aggregate_beams(beams) do
    beams
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(fn {i, ns} -> {i, Enum.sum(ns)} end)
  end

  defp parse(input_string) do
    [first | others] =
      input_string
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    start_pos = first |> Enum.find_index(&(&1 == "S"))

    others =
      for line <- others do
        line
        |> Enum.with_index()
        |> Enum.filter(fn {x, _} -> x == "^" end)
        |> Enum.map(&elem(&1, 1))
      end

    {start_pos, others}
  end
end
