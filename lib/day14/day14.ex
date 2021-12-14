defmodule V2021.Day14 do
  @input_file_part1 "lib/day14/input.txt"
  @input_file_part2 "lib/day14/input.txt"
  @goal1 10
  @goal2 40

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> solve(@goal1)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> solve(@goal2)
    |> IO.inspect()
  end

  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n\n")
    |> List.to_tuple()
    |> parse_instructions()
  end

  # INPUT PARSING
  def parse_instructions({template, raw_instructions}) do
    {
      String.graphemes(template),
      raw_instructions
      |> String.split("\n")
      |> Enum.map(&parse_instruction/1)
      |> Enum.into(%{})
    }
  end

  def parse_instruction(raw_instruction) do
    raw_instruction
    |> String.split(" -> ")
    |> List.to_tuple()
  end

  # SOLUTION
  def solve({polymer, pair_rules}, goal) do
    1..goal
    |> Enum.reduce(polymer |> pairs(), fn _step, pairs -> grow(pairs, pair_rules) end)
    |> frequencies(polymer)
    |> Map.values()
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
  end

  def pairs(polymer) do
    polymer
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join/1)
    |> Enum.frequencies()
  end

  def grow(pairs, pair_rules) do
    Enum.reduce(pairs, %{}, fn {pair, current_amount}, acc ->
      [first, last] = String.graphemes(pair)
      medial = pair_rules[pair]

      acc
      |> Map.update(first <> medial, current_amount, &(&1 + current_amount))
      |> Map.update(medial <> last, current_amount, &(&1 + current_amount))
    end)
  end

  def frequencies(pairs, initial_polymer) do
    last = List.last(initial_polymer)

    Enum.reduce(pairs, %{last => 1}, fn {pair, count}, acc ->
      [first, _] = String.graphemes(pair)
      Map.update(acc, first, count, fn c -> c + count end)
    end)
  end
end
