defmodule V2021.Day7 do
  @input_file_part1 "lib/day7/input.txt"
  @input_file_part2 "lib/day7/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> distance_to_median()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> summation_distance_to_average()
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
  def distance_to_median(positions) do
    positions
    |> median()
    |> compute_distance(positions)
  end

  def median(numbers) do
    numbers
    |> Enum.sort()
    |> Enum.at(div(Enum.count(numbers), 2))
  end

  def compute_distance(median, positions), do: Enum.reduce(positions, 0, fn pos, acc -> acc + abs(pos - median) end)

  # PART 2
  def summation_distance_to_average(positions) do
    positions
    |> avg()
    |> compute_summation_distance(positions)
  end

  def avg(numbers) do
    numbers
    |> Enum.sum()
    |> Kernel./(Enum.count(numbers))
    |> trunc()
  end

  def compute_summation_distance(average, positions) do
    positions
    |> Enum.reduce(0, fn pos, acc -> acc + summation(abs(pos - average)) end)
  end

  def summation(n), do: div(n * n + n, 2)
end
