defmodule V2021.Day1 do
  @input_file_part1 "lib/day1/input.txt"
  @input_file_part2 "lib/day1/input.txt"
  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> count_increase_depth(0)
    |> IO.puts()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> count_increase_depth_window(0)
    |> IO.puts()
  end

  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer(&1))
  end

  def count_increase_depth([_ | []], count), do: count
  def count_increase_depth([current, next | rest], count) do
    new_count = maybe_increase_count(count, next > current)

    count_increase_depth([next] ++ rest, new_count)
  end

  def count_increase_depth_window([_, _, _ | []], count), do: count
  def count_increase_depth_window([a, b, c, d | rest], count) do
    new_count = maybe_increase_count(count, b + c + d > a + b + c)

    count_increase_depth_window([b, c, d] ++ rest, new_count)
  end

  def maybe_increase_count(count, condition) do
    if condition do
      count + 1
    else
      count
    end
  end
end
