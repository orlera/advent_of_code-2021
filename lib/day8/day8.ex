defmodule V2021.Day8 do
  @input_file_part1 "lib/day8/input.txt"
  @input_file_part2 "lib/day8/input.txt"

  @codes_map %{
    "abcefg" => "0",
    "cf" => "1",
    "acdeg" => "2",
    "acdfg" => "3",
    "bcdf" => "4",
    "abdfg" => "5",
    "abdefg" => "6",
    "acf" => "7",
    "abcdefg" => "8",
    "abcdfg" => "9"
  }

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> count()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> compute_outputs()
    |> IO.inspect()
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
  def count(inputs), do: Enum.reduce(inputs, 0, fn input, acc -> easy_digits_count(input) + acc end)

  def easy_digits_count({_, outputs}), do: Enum.count(outputs, &Enum.member?([2,3,4,7], String.length(&1)))

  # PART 2
  def compute_outputs(inputs) do
    Enum.map(inputs, fn {samples, outputs} ->
      map_letters(samples)
      |> fix_outputs(outputs)
      |> Enum.map(&code_to_number/1)
      |> Enum.join()
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def map_letters(samples) do
    letters_initial_map(samples)
    |> assign_rest(samples)
  end

  def letters_initial_map(samples) do
    occurences_map =
      samples
      |> Enum.join()
      |> String.graphemes()
      |> Enum.reduce(%{}, fn letter, acc -> Map.update(acc, letter, 1, &(&1 + 1)) end)

    %{
      "a" => nil,
      "b" => find_by_value(occurences_map, 6),
      "c" => nil,
      "d" => find_by_value(occurences_map, 7),
      "e" => find_by_value(occurences_map, 4),
      "f" => find_by_value(occurences_map, 9),
      "g" => find_by_value(occurences_map, 7, 1)
    }
  end

  def find_by_value(map, target, index \\ 0) do
    map
    |> Enum.filter(fn {_, v} -> v == target end)
    |> Enum.at(index)
    |> elem(0)
  end

  def assign_rest(letters_map, samples) do
    length_map = length_map(samples)
    one = length_map |> find_by_value(2)
    seven = length_map |> find_by_value(3)
    swap_b_g =
    length_map
    |> find_by_value(4)
    |> String.graphemes()
    |> Enum.member?(Map.get(letters_map, "g"))

    letters_map
    |> Map.update!("a", fn _ -> String.graphemes(seven) -- String.graphemes(one) |> List.first() end)
    |> Map.update!("c", fn _ -> String.graphemes(one) -- [Map.get(letters_map, "f")] |> List.first() end)
    |> maybe_swap_d_g(swap_b_g)
  end

  def maybe_swap_d_g(letters_map, false), do: letters_map
  def maybe_swap_d_g(letters_map, true) do
    old_g = Map.get(letters_map, "g")

    letters_map
    |> Map.update!("g", fn _ -> Map.get(letters_map, "d") end)
    |> Map.update!("d", fn _ -> old_g end)
  end

  def length_map(samples), do: Enum.map(samples, &({&1, String.length(&1)}))

  def fix_outputs(letters_map, outputs) do
    Enum.map(outputs, fn output -> fix_output(letters_map, output) end)
  end

  def fix_output(letters_map, output) do
    output
    |> String.graphemes()
    |> Enum.map(&(find_by_value(letters_map, &1)))
    |> Enum.sort()
    |> Enum.join()
  end

  def code_to_number(output), do: Map.get(@codes_map, output)
end
