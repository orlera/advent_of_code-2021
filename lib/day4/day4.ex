defmodule V2021.Day4 do
  @input_file_part1 "lib/day4/input.txt"
  @input_file_part2 "lib/day4/input.txt"
  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> draw_numbers(4)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    # |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    [drawn_numbers | boards] =
      input
      |> File.read!()
      |> String.split("\n\n")

    {
      drawn_numbers
      |> String.split(",")
      |> Enum.map(&String.to_integer/1),
      boards
      |> Enum.map(&board_to_matrix/1)
    }
  end

  def board_to_matrix(string_board) do
    string_board
    |> String.split("\n")
    |> Enum.map(fn row ->
      String.split(row)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  # PART 1
  def draw_numbers({numbers, boards} = setup, game_step) do
    drawn_numbers = Enum.take(numbers, game_step)

    with {:ok, board} <- check_boards(boards, drawn_numbers, []) do
      sum_unmarked_numbers(board, drawn_numbers) * Enum.at(drawn_numbers, -1)
    else
      _ -> draw_numbers(setup, game_step + 1)
    end
  end

  def winning_board(boards, numbers) do
    Enum.each(boards, fn board ->
      check_rows(board, numbers, [])
    end)
  end

  def check_boards([], _numbers, []), do: []
  def check_boards([current_board | rest], numbers, bingo) do
    bingo_row = check_rows(current_board, numbers, bingo)
    bingo_column = check_columns(current_board, numbers, bingo, 0)

    cond do
      Enum.any?(bingo_row) -> {:ok, current_board}
      Enum.any?(bingo_column) -> {:ok, current_board}
      true -> check_boards(rest, numbers, bingo)
    end
  end
  def check_boards(_boards, _numbers, bingo), do: bingo

  def check_rows([], _numbers, []), do: []
  def check_rows([current_row | rest], numbers, []) do
    bingo =
      cond do
        Enum.empty?(current_row -- numbers) -> current_row
        true -> []
      end
    check_rows(rest, numbers, bingo)
  end
  def check_rows(_board, _numbers, bingo), do: bingo

  def check_columns(_board, _numbers, [], 5), do: []
  def check_columns(board, numbers, [], index) do
    current_column = column_at(board, index)
    bingo =
      cond do
        Enum.empty?(current_column -- numbers) -> current_column
        true -> []
      end

    check_columns(board, numbers, bingo, index + 1)
  end
  def check_columns(_board, _numbers, bingo, _index), do: bingo

  def column_at(board, index) do
    board
    |> Enum.map(fn row ->
      Enum.at(row, index)
    end)
  end

  def sum_unmarked_numbers(board, numbers) do
    board_numbers = List.flatten(board)
    Enum.sum(board_numbers -- numbers)
  end
end
