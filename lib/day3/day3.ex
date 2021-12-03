defmodule V2021.Day3 do
  @input_file_part1 "lib/day3/input.txt"
  @input_file_part2 "lib/day3/input.txt"
  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> calculate_gamma()
    |> calculate_epsilon()
    |> calculate_power()
    |> IO.inspect()
  end

  def solution_part2() do
    input_list =
      @input_file_part2
      |> parse_input()

    oxygen = search_oxygen(input_list, "", 0)
    co2 = search_co2(input_list, "", 0)

    [oxygen, co2]
    |> calculate_power()
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n")
  end

  # PART 1
  def calculate_gamma(lines) do
    initial_value = List.duplicate(0, lines |> List.first() |> String.length())
    target_occurrences = Enum.count(lines) / 2

    lines
    |> Enum.reduce(initial_value, fn line, acc ->
      line
      |> line_to_integers()
      |> sum_lines(acc)
    end)
    |> Enum.map(&most_occurrences(&1, target_occurrences))
  end

  def line_to_integers(line) do
    line
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def sum_lines(line, partial) do
    Enum.zip_reduce([partial, line], [], fn elems, acc ->
      acc ++ [Enum.sum(elems)]
    end)
  end

  def most_occurrences(occurences, target) when occurences > target, do: "1"
  def most_occurrences(_occurences, _target), do: "0"

  def calculate_epsilon(gamma) do
    epsilon = Enum.map(gamma, &flip/1)

    [List.to_string(gamma), List.to_string(epsilon)]
  end

  def flip("1"), do: "0"
  def flip("0"), do: "1"

  def calculate_power(rates) do
    rates
    |> Enum.map(fn rate ->
      rate
      |> Integer.parse(2)
      |> elem(0)
    end)
    |> Enum.product()
  end

  # PART 2

  def search_oxygen(input_list, current_target, index) do
    new_target =
      cond do
        Enum.count(input_list, &String.at(&1, index) == "1") < Enum.count(input_list) / 2 -> current_target <> "0"
        true -> current_target <> "1"
      end

    filtered_list = Enum.filter(input_list, &String.starts_with?(&1, new_target))

    cond do
      Enum.count(filtered_list) == 1 ->
        List.first(filtered_list)
      true ->
        search_oxygen(filtered_list, new_target, index + 1)
    end
  end

  def search_co2(input_list, current_target, index) do
    new_target =
      cond do
        Enum.count(input_list, &String.at(&1, index) == "0") > Enum.count(input_list) / 2 -> current_target <> "1"
        true -> current_target <> "0"
      end

    filtered_list = Enum.filter(input_list, &String.starts_with?(&1, new_target))

    cond do
      Enum.count(filtered_list) == 1 ->
        List.first(filtered_list)
      true ->
        search_co2(filtered_list, new_target, index + 1)
    end
  end
end
