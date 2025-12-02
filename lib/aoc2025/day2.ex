defmodule Aoc2025.Day2 do
  def example() do
    """
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
    1698522-1698528,446443-446449,38593856-38593862,565653-565659,
    824824821-824824827,2121212118-2121212124
    """
    |> String.split("\n")
    |> Enum.join("")
  end

  def part1(input_string) do
    input_string
    |> parse()
    |> Enum.flat_map(fn {a, b} -> normalize_range(a, b) end)
    |> Enum.map(&get_bad_numbers(&1, :twice))
    |> Stream.concat()
    |> Enum.sum()
  end

  def part2(input_string) do
    input_string
    |> parse()
    |> Enum.flat_map(fn {a, b} -> normalize_range(a, b) end)
    |> Enum.map(&get_bad_numbers(&1, :all))
    |> Stream.concat()
    |> Enum.sum()
  end

  defp parse(input_string) do
    input_string
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_range/1)
  end

  defp parse_range(range_string) do
    [a, b] = String.split(range_string, "-") |> Enum.map(&String.to_integer/1)
    {a, b}
  end

  defp normalize_range(a, b) do
    a_digits = n_digits(a)
    b_digits = n_digits(b)

    if a_digits == b_digits do
      [{a, b}]
    else
      bound = :math.pow(10, a_digits) |> round()
      [{a, bound - 1} | normalize_range(bound, b)]
    end
  end

  defp get_bad_numbers({a, b}, type) do
    a
    |> n_digits()
    |> rep_divisors(type)
    |> Enum.flat_map(fn d ->
      lb = div(a + d - 1, d)
      ub = div(b, d)

      if lb <= ub do
        for i <- lb..ub, do: i * d
      else
        []
      end
    end)
    |> Enum.uniq()
  end

  defp n_digits(n), do: n |> Integer.digits() |> length()

  defp divisors(1), do: []
  defp divisors(n), do: Enum.filter(1..(n - 1), &(rem(n, &1) == 0))

  defp rep_divisors(num_len, :all) do
    for d <- divisors(num_len) do
      rep_part = Tuple.duplicate(0, d) |> put_elem(d - 1, 1) |> Tuple.to_list()

      1..div(num_len, d)
      |> Enum.flat_map(fn _ -> rep_part end)
      |> Integer.undigits()
    end
  end

  defp rep_divisors(num_len, :twice) when rem(num_len, 2) == 1, do: []

  defp rep_divisors(num_len, :twice) do
    d = div(num_len, 2)
    rep_part = Tuple.duplicate(0, d) |> put_elem(d - 1, 1) |> Tuple.to_list()
    [Integer.undigits(rep_part ++ rep_part)]
  end
end
