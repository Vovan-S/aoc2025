defmodule Aoc2025.Day6 do
  def example do
    """
    123 328  51 64 
     45 64  387 23 
      6 98  215 314
    *   +   *   +  
    """
  end

  def part1(input_string) do
    input_string
    |> parse1()
    |> Enum.sum_by(&calculate/1)
  end

  def part2(input_string) do
    input_string
    |> parse2()
    |> Enum.sum_by(&calculate/1)
  end

  defp calculate({"*", nums}), do: Enum.product(nums)
  defp calculate({"+", nums}), do: Enum.sum(nums)

  defp parse1(input_string) do
    input_string
    |> String.trim()
    |> String.split("\n")
    |> Enum.reverse()
    |> Enum.map(&String.split/1)
    |> Enum.zip()
    |> Enum.map(fn col ->
      [op | numbers] = Tuple.to_list(col)
      numbers = numbers |> Enum.map(&String.to_integer/1) |> Enum.reverse()
      {op, numbers}
    end)
  end

  defp parse2(input_string) do
    [ops | numbers] =
      input_string
      |> String.trim()
      |> String.split("\n")
      |> Enum.reverse()

    {numbers, last_acc} =
      numbers
      |> Enum.map(fn line -> line |> String.to_charlist() |> Enum.reverse() end)
      |> Enum.zip()
      |> Enum.reduce({[], []}, fn digits, {all, current} ->
        digits =
          digits
          |> Tuple.to_list()
          |> Enum.reject(&(&1 == ?\s))
          |> Enum.map(&(&1 - ?0))
          |> Enum.reverse()

        case digits do
          [] -> {[current | all], []}
          digits -> {all, [Integer.undigits(digits) | current]}
        end
      end)

    numbers = [last_acc | numbers]
    ops = String.split(ops)
    Enum.zip(ops, numbers)
  end
end
