defmodule V2021.Day2 do
  @input_file_part1 "lib/day2/input.txt"
  @input_file_part2 "lib/day2/input.txt"
  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> execute_plan_part_1()
    |> Tuple.product()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> execute_plan_part_2()
    |> multiply()
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [direction, step] = String.split(line)
    %{ direction: direction, unit: String.to_integer(step) }
  end

  # PART 1
  def execute_plan_part_1(plan), do: Enum.reduce(plan, {0, 0}, &execute_step_part_1/2)

  def execute_step_part_1(%{direction: "up", unit: unit}, {x, y}), do: {x, y - unit}
  def execute_step_part_1(%{direction: "down", unit: unit}, {x, y}), do: {x, y + unit}
  def execute_step_part_1(%{direction: "forward", unit: unit}, {x, y}), do: {x + unit, y}

  # PART 2
  def execute_plan_part_2(plan), do: Enum.reduce(plan, {0, 0, 0}, &execute_step_part_2/2)

  def execute_step_part_2(%{direction: "up", unit: unit}, {x, y, a}), do: {x, y, a - unit}
  def execute_step_part_2(%{direction: "down", unit: unit}, {x, y, a}), do: {x, y, a + unit}
  def execute_step_part_2(%{direction: "forward", unit: unit}, {x, y, a}), do: {x + unit, y + a * unit, a}

  def multiply({x, y, _}), do: x * y
end
