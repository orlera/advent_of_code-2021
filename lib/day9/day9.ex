defmodule V2021.Day9 do
  @input_file_part1 "lib/day9/input.txt"
  @input_file_part2 "lib/day9/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> scan_for_low_points()
    |> Enum.reduce(0, fn low_point, acc -> acc + low_point + 1 end)
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
      |> String.graphemes()
      |> Enum.map(&(String.to_integer(&1)))
    end)
  end

  # PART 1
  def scan_for_low_points(altitude_matrix) do
    altitude_matrix
    |> Enum.with_index(& {&2, &1})
    |> Enum.reduce([], fn {y, row}, acc ->
      [
        row
        |> Enum.with_index(& {&2, &1})
        |> Enum.reduce([], fn {x, altitude}, row_acc ->
          cond do
            is_low_point(altitude, {x, y}, altitude_matrix) -> [altitude | row_acc]
            true -> row_acc
          end
        end)
        | acc ]
    end)
    |> List.flatten()
  end

  def is_low_point(altitude, {x, y}, altitude_matrix) do
      altitude < get_altitude_for(altitude_matrix, {x, y-1}) &&
      altitude < get_altitude_for(altitude_matrix, {x-1, y}) &&
      altitude < get_altitude_for(altitude_matrix, {x+1, y}) &&
      altitude < get_altitude_for(altitude_matrix, {x, y+1})
  end

  def get_altitude_for(_altitude_matrix, {x, y}) when x < 0 or y < 0, do: 10
  def get_altitude_for(_altitude_matrix, {x, y}) when x > 99 or y > 99, do: 10
  def get_altitude_for(altitude_matrix, {x, y}) do
    altitude_matrix
    |> Enum.at(y)
    |> Enum.at(x)
  end
end
