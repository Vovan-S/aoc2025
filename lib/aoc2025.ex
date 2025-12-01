defmodule Aoc2025 do
  @moduledoc """
  Documentation for `Aoc2025`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc2025.hello()
      :world

  """
  def hello do
    :world
  end

  def read(file) do
    Path.join(["priv", "inputs", file])
    |> File.read!()
  end
end
