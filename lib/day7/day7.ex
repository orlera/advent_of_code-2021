defmodule V2021.Day7 do
  @input_file_part1 "lib/day7/input.txt"
  @input_file_part2 "lib/day7/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> minmax()
    |> simple_distances()
    |> extract_least_expensive()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> minmax()
    |> summation_distances()
    |> extract_least_expensive()
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  # PART 1
  def minmax(positions) do
    {positions, Enum.min_max(positions)}
  end

  def simple_distances({positions, {min, max}}) do
    min..max
    |> Enum.map(&({&1, distance_for(positions, &1)}))
  end

  def distance_for(positions, target) do
    positions
    |> Enum.map(&abs(Kernel.-(&1, target)))
    |> Enum.sum()
  end

  def extract_least_expensive(distances) do
    distances
    |> Enum.sort_by(& elem(&1, 1))
    |> List.first()
    |> elem(1)
  end

  # PART 2
  def summation_distances({positions, {min, max}}) do
    min..max
    |> Enum.map(&({&1, summation_distance_for(positions, &1)}))
  end

  def summation_distance_for(positions, target) do
    positions
    |> Enum.reduce(%{}, fn position, acc ->
      Map.update(acc, abs(target-position), 1, &(&1+1))
    end)
    |> Enum.map(&(summation(elem(&1, 0)) * elem(&1, 1)))
    |> Enum.sum()
  end

  def summation(n), do: Enum.sum(1..n)
end
