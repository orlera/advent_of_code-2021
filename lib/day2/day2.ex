defmodule V2021.Day2 do
  @input_file_part1 "lib/day2/input.txt"
  @input_file_part2 "lib/day2/input.txt"
  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> execute_plan()
    |> Tuple.product()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> IO.inspect()
  end

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

  def execute_plan(plan) do
    Enum.reduce(plan, {0, 0}, &execute_step/2)
  end

  def execute_step(step, state) do
    case step[:direction] do
      "up" -> {elem(state, 0), elem(state, 1) - step[:unit]}
      "down" -> {elem(state, 0), elem(state, 1) + step[:unit]}
      "forward" -> {elem(state, 0) + step[:unit], elem(state, 1)}
    end
  end
end
