defmodule V2021.Day6 do
  @input_file_part1 "lib/day6/input.txt"
  @input_file_part2 "lib/day6/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> simulate_reproduction(80)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def simulate_reproduction(base_lanternfish, target_day) do
    base_lanternfish
    |> Enum.map(&reproduct(&1, target_day))
    |> Enum.sum()
  end

  def reproduct(day_start, target_day) when target_day - day_start <= 0, do: 1
  def reproduct(day_start, target_day), do: reproduct(day_start + 7, target_day) + reproduct(day_start + 9, target_day)
end
