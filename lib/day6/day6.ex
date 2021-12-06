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
    |> simulate_reproduction(256)
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn age, acc -> Map.update(acc, age, 1, &(&1 + 1)) end)
  end

  def simulate_reproduction(lanterfish_ages, target_day) do
    lanterfish_ages
    |> Map.keys()
    |> Enum.map(&reproduct(&1, target_day))
    |> Enum.zip(Map.values(lanterfish_ages))
    |> Enum.reduce(0, fn {kids, occurences}, acc -> acc + kids * occurences end)
  end

  def reproduct(day_start, target_day) when target_day - day_start <= 0, do: 1
  def reproduct(day_start, target_day), do: reproduct(day_start + 7, target_day) + reproduct(day_start + 9, target_day)
end
