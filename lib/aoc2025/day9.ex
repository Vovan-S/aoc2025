defmodule Aoc2025.Day9 do
  def example do
    """
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3      
    """
  end

  def part1(input_string) do
    input_string
    |> parse()
    |> max_square(0)
  end

  def part2(input_string) do
    pts = input_string |> parse()

    {x_edges, y_edges} =
      pts
      |> find_edges_and_directions()
      |> Enum.split_with(fn {{x1, _}, {x2, _}, _} -> x1 == x2 end)

    edges = {normalize_edges(x_edges, 0), normalize_edges(y_edges, 1)}
    max_square_inside(pts, edges)
  end

  defp max_square_inside(pts, edges, curr_max \\ 0)
  defp max_square_inside([_], _, curr_max), do: curr_max

  defp max_square_inside([p | rest], edges, curr_max) do
    new_max =
      rest
      |> Enum.map(fn p2 -> {p, p2} end)
      |> Enum.filter(&good_rect?(&1, edges))
      |> Enum.map(fn {p1, p2} -> square(p1, p2) end)
      |> Enum.max(fn -> curr_max end)

    max_square_inside(rest, edges, max(new_max, curr_max))
  end

  defp good_rect?({{x1, y1}, {x2, y2}}, {x_edges, y_edges}) do
    inside?(x1, y2, x_edges, y_edges) and
      inside?(x2, y1, x_edges, y_edges) and
      not goes_out?(x1, x2, y1, x_edges) and
      not goes_out?(x1, x2, y2, x_edges) and
      not goes_out?(y1, y2, x1, y_edges) and
      not goes_out?(y1, y2, x2, y_edges)
  end

  defp inside?(x, y, x_edges, y_edges) do
    with {n, false} when n > 0 <-
           Enum.reduce_while(x_edges, {0, false}, &count_around(&1, &2, x, y)),
         {n, false} when n > 0 <-
           Enum.reduce_while(y_edges, {0, false}, &count_around(&1, &2, y, x)) do
      true
    else
      {_, true} -> true
      _ -> false
    end
  end

  defp goes_out?(x1, x2, y, x_edges) when x2 < x1, do: goes_out?(x2, x1, y, x_edges)

  defp goes_out?(x1, x2, y, x_edges) do
    Enum.any?(x_edges, fn {x, y1..y2//_, _} -> y in (y1 + 1)..(y2 - 1) and x1 < x and x2 > x end)
  end

  defp count_around({x_edge, ys, dx}, {n, _}, x, y) do
    cond do
      y not in ys -> {:cont, {n, false}}
      x == x_edge -> {:halt, {0, true}}
      true -> {:cont, {n + sign((x - x_edge) * dx), false}}
    end
  end

  defp normalize_edges(edges, ix) do
    for {p1, p2, dp} <- edges do
      x = elem(p1, ix)
      y1 = elem(p1, 1 - ix)
      y2 = elem(p2, 1 - ix)
      {x, min(y1, y2)..max(y1, y2), elem(dp, ix)}
    end
  end

  defp find_edges_and_directions(pts) do
    min_x = Stream.map(pts, &elem(&1, 0)) |> Enum.min()
    [first, second | _] = pts = find_x_edge(pts, min_x, [])

    (pts ++ [first, second])
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map_reduce({1, 0}, &find_edges_and_directions/2)
    |> elem(0)
  end

  defp find_edges_and_directions([{x1, y1} = p1, {x2, y2} = p2, {x3, y3}], {dx, dy} = dp) do
    v1 = {x2 - x1, y2 - y1}
    v2 = {x3 - x2, y3 - y2}
    c_1_2 = clockwise(v1, v2)
    new_dir = {c_1_2 * dy, -c_1_2 * dx}
    {{p1, p2, dp}, new_dir}
  end

  defp clockwise({dx1, dy1}, {dx2, dy2}), do: -sign(dx1 * dy2 - dx2 * dy1)

  defp sign(x) when x > 0, do: 1
  defp sign(x) when x < 0, do: -1
  defp sign(x) when x == 0, do: 0

  defp find_x_edge(pts, x, visited) do
    case pts do
      [{x1, _}, {x2, _} | _] when x1 == x2 and x1 == x -> pts ++ Enum.reverse(visited)
      [{x1, _} = p] when x1 == x -> [p | Enum.reverse(visited)]
      [p | rest] -> find_x_edge(rest, x, [p | visited])
      _ -> raise "Cannot find edge with x=#{x}"
    end
  end

  defp max_square([_], curr_max), do: curr_max

  defp max_square([p1 | pts], curr_max) do
    new_max = Enum.map(pts, fn p2 -> square(p1, p2) end) |> Enum.max()
    max_square(pts, max(curr_max, new_max))
  end

  defp square({x1, y1}, {x2, y2}) do
    dx = max(x1, x2) - min(x1, x2) + 1
    dy = max(y1, y2) - min(y1, y2) + 1
    dx * dy
  end

  defp parse(input_string) do
    for line <- input_string |> String.trim() |> String.split("\n") do
      [x, y] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
      {x, y}
    end
  end
end
