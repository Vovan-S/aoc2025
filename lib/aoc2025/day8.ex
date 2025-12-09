defmodule Aoc2025.Day8 do
  def example do
    """
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    """
  end

  def part1(input_string, n \\ 1000) do
    pts = input_string |> parse() |> Enum.with_index()
    ds = calculate_distances(pts) |> Enum.sort_by(&elem(&1, 2))

    reduce_clusters(pts, ds, n)
    |> Enum.sort_by(fn {_, pts} -> length(pts) end, :desc)
    |> Enum.take(3)
    |> Enum.product_by(fn {_, pts} -> length(pts) end)
  end

  def part2(input_string) do
    pts = input_string |> parse() |> Enum.with_index()
    ds = calculate_distances(pts) |> Enum.sort_by(&elem(&1, 2))
    {ix_1, ix_2} = find_first_connecting(pts, ds)
    {{x1, _, _}, _} = Enum.at(pts, ix_1)
    {{x2, _, _}, _} = Enum.at(pts, ix_2)
    x1 * x2
  end

  defp make_cluster_index(pts) do
    clusters = for {_, ix} <- pts, into: %{}, do: {ix, [ix]}
    pts_to_clusters = for {_, ix} <- pts, into: %{}, do: {ix, ix}
    {clusters, pts_to_clusters}
  end

  defp reduce_clusters(pts, ds, n) do
    {clusters, pts_to_clusters} = make_cluster_index(pts)
    reduce_clusters(clusters, pts_to_clusters, ds, n)
  end

  defp reduce_clusters(clusters, pts_to_cluster, ds, n)

  defp reduce_clusters(clusters, _, _, 0), do: clusters

  defp reduce_clusters(clusters, pts_to_cluster, [{ix_1, ix_2, _} | ds], n) do
    {clusters, pts_to_cluster} = make_next_connection(clusters, pts_to_cluster, ix_1, ix_2)
    reduce_clusters(clusters, pts_to_cluster, ds, n - 1)
  end

  defp find_first_connecting(pts, ds) do
    {clusters, pts_to_clusters} = make_cluster_index(pts)
    find_first_connecting(clusters, pts_to_clusters, ds, nil)
  end

  defp find_first_connecting(clusters, pts_to_cluster, ds, last)

  defp find_first_connecting(clusters, _, _, last) when map_size(clusters) == 1, do: last

  defp find_first_connecting(clusters, pts_to_cluster, [{ix_1, ix_2, _} | ds], _) do
    {clusters, pts_to_cluster} = make_next_connection(clusters, pts_to_cluster, ix_1, ix_2)
    find_first_connecting(clusters, pts_to_cluster, ds, {ix_1, ix_2})
  end

  defp make_next_connection(clusters, pts_to_clusters, ix_1, ix_2) do
    cluster_1 = pts_to_clusters[ix_1]
    cluster_2 = pts_to_clusters[ix_2]

    if cluster_1 == cluster_2 do
      {clusters, pts_to_clusters}
    else
      merge_clusters(clusters, pts_to_clusters, cluster_1, cluster_2)
    end
  end

  defp merge_clusters(clusters, pts_to_cluster, c1, c2)

  defp merge_clusters(clusters, pts_to_cluster, c_ix1, c_ix2) when c_ix2 < c_ix1,
    do: merge_clusters(clusters, pts_to_cluster, c_ix2, c_ix1)

  defp merge_clusters(clusters, pts_to_cluster, c_ix1, c_ix2) do
    c1 = clusters[c_ix1]
    c2 = clusters[c_ix2]
    clusters = Map.put(clusters, c_ix1, c1 ++ c2) |> Map.delete(c_ix2)
    pts_to_cluster = Enum.reduce(c2, pts_to_cluster, fn ix, m -> Map.put(m, ix, c_ix1) end)
    {clusters, pts_to_cluster}
  end

  defp calculate_distances(pts, ds \\ [])

  defp calculate_distances([], ds), do: ds

  defp calculate_distances([{p1, ix_1} | rest], ds) do
    ds =
      Enum.reduce(rest, ds, fn {p2, ix_2}, d ->
        [{ix_1, ix_2, distance(p1, p2)} | d]
      end)

    calculate_distances(rest, ds)
  end

  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    dx = x1 - x2
    dy = y1 - y2
    dz = z1 - z2
    :math.sqrt(dx * dx + dy * dy + dz * dz)
  end

  defp parse(input_string) do
    for line <- input_string |> String.trim() |> String.split("\n") do
      [x, y, z] = line |> String.split(",") |> Enum.map(&String.to_integer/1)
      {x, y, z}
    end
  end
end
