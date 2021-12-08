defmodule V2021.Day8 do
  @input_file_part1 "lib/day8/input.txt"
  @input_file_part2 "lib/day8/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> count_easy()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split("|")
      |> Enum.map(&(String.split(&1)))
      |> List.to_tuple()
    end)
  end

  # PART 1
  def count_easy(inputs), do: Enum.reduce(inputs, 0, fn input, acc -> easy_digits_count(input) + acc end)

  def easy_digits_count({_, outputs}), do: Enum.count(outputs, &Enum.member?([2,3,4,7], String.length(&1)))
end
