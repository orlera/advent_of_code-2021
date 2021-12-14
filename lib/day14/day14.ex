defmodule V2021.Day14 do
  @input_file_part1 "lib/day14/input.txt"
  @input_file_part2 "lib/day14/input.txt"
  @step1_goal 10
  @step2_goal 40

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> step(0, @step1_goal)
    |> compute_score()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> step(0, @step2_goal)
    |> compute_score()
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n\n")
    |> List.to_tuple()
    |> parse_instructions()
  end

  def parse_instructions({template, raw_instructions}) do
    {
      template,
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

  # PART 1
  def step(input, step, step_goal) when step == step_goal, do: input
  def step({pattern, _} = input, step, step_goal) do
    input
    |> instertions(String.slice(pattern, 0..0))
    |> step(step + 1, step_goal)
  end

  def instertions({<<first::utf8>> <> <<second::utf8>> <> rest, instructions}, output), do: instertions({<<second::utf8>> <> rest, instructions}, output <> Map.get(instructions, <<first::utf8>><><<second::utf8>>, "") <> <<second::utf8>>)
  def instertions({_, instructions}, output), do: {output, instructions}

  def compute_score({output, _}) do
    output
    |> String.graphemes()
    |> Enum.frequencies()
    |> min_max()
    |> Enum.sum()
  end

  def min_max(frequencies) do
    min_max = Enum.min_max_by(frequencies, &(elem(&1, 1)))
    [min_max |> elem(1) |> elem(1), -(min_max |> elem(0) |> elem(1))]
  end
end
