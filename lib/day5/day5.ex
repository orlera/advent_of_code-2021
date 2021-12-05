defmodule V2021.Day5 do
  @input_file_part1 "lib/day5/input.txt"
  @input_file_part2 "lib/day5/input.txt"
  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> draw_lines(List.duplicate(0, 1000) |> List.duplicate(1000))
    |> List.flatten()
    |> Enum.count(fn el -> el > 1 end)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    # |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " -> ")
      |> Enum.map(&string_to_point/1)
      |> List.to_tuple()
    end)
  end

  def string_to_point(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  # PART 1
  def draw_lines([], matrix), do: matrix
  def draw_lines([current_line | lines], matrix) do
    updated_matrix = maybe_update_matrix(matrix, current_line)
    draw_lines(lines, updated_matrix)
  end

  def maybe_update_matrix(matrix, {{x1, y1}, {x2, y2}}) when x1 == x2 do
    matrix
    |> Enum.with_index(fn row, index ->
      List.replace_at(row, x1, maybe_increase(Enum.at(row, x1), [y1, index, y2] |> Enum.sort() |> Enum.at(1) == index))
    end)
  end

  def maybe_update_matrix(matrix, {{x1, y1}, {x2, y2}}) when y1 == y2 do
    new_row =
      matrix
      |> Enum.at(y1)
      |> Enum.with_index(fn el, index ->
        maybe_increase(el, [x1, index, x2] |> Enum.sort() |> Enum.at(1) == index)
      end)

    List.replace_at(matrix, y1, new_row)
  end
  def maybe_update_matrix(matrix, _), do: matrix

  def maybe_increase(el, true), do: el+1
  def maybe_increase(el, false), do: el
end
