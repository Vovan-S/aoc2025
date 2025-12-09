defmodule Aoc2025.Day1 do
  def example() do
    """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """
  end

  def part1(input_string) do
    parse(input_string)
    |> Enum.reduce(
      {0, 50},
      fn rot, {n_zeros, current} ->
        current = rotate(current, rot)
        current = rem(current + 100, 100)
        n_zeros = if current == 0, do: n_zeros + 1, else: n_zeros
        {n_zeros, current}
      end
    )
  end

  def part2(input_string) do
    parse(input_string)
    |> Enum.reduce(
      {0, 50},
      fn {dir, amount}, {n_zeros, current} ->
        full_passes = div(amount, 100)
        new_value = rotate(current, {dir, rem(amount, 100)})
        n_zeros = n_zeros + n_passes(current, new_value) + full_passes
        new_value = rem(new_value + 100, 100)
        {n_zeros, new_value}
      end
    )
  end

  defp rotate(current, direction)

  defp rotate(current, {:left, amount}), do: current - amount
  defp rotate(current, {:right, amount}), do: current + amount

  defp n_passes(old_value, new_value)

  defp n_passes(0, _), do: 0
  defp n_passes(_, new_value) when new_value <= 0 or new_value >= 100, do: 1
  defp n_passes(_, _), do: 0

  defp parse(input_string) do
    input_string
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn
      "L" <> num -> {:left, String.to_integer(num)}
      "R" <> num -> {:right, String.to_integer(num)}
    end)
  end
end
