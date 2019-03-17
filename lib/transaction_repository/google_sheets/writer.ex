defmodule TransactionRepository.GoogleSheets.Writer do
  @moduledoc false

  @enforce_keys [:categories, :category_to_index]
  defstruct @enforce_keys

  def row_writer(sheet) do
    fn {ranges, rows} -> GSS.Spreadsheet.write_rows(sheet, ranges, rows) end
  end



  def write_transactions(config, transactions, write_rows) do
    transactions
    |> to_sorted_transaction_list(initial_txn_list(config.categories), config.category_to_index)
    |> to_rows
    |> build_ranges(1)
    |> write_rows.()
  end

  defp initial_txn_list(categories), do: List.duplicate([], length(categories))


  def to_sorted_transaction_list(txns, initial_txn_list, category_to_index) do

    Enum.reduce(txns, initial_txn_list, fn (txn, txn_list) ->
      index = category_to_index.(txn.category)

      category_txns = Enum.at(txn_list, index)
      new_category_txns = [serialize_transaction(txn) | category_txns]

      List.replace_at(txn_list, index, new_category_txns)
    end)
  end


  defp serialize_transaction(txn) do
    serialized_txn = [txn.description, "8/25/1973"]

    amount = case txn.category do
      :Income -> txn.credit
      _       -> txn.debit
    end

    serialized_txn ++ case txn.owner do
      "Matt"    -> [amount, ""]
      "Jessica" -> ["", amount]
    end
  end

  def to_rows(txn_list) do
    max_txn_count = txn_list |> Enum.map(&length/1) |> Enum.max

    txn_list
    |> Enum.map(fn txns ->
         txn_count_diff = max_txn_count - length(txns)
         sort(txns) ++ List.duplicate(empty_transaction(), txn_count_diff)
       end)
    |> convert_to_rows(max_txn_count - 1)
  end

  def sort(txns) do
    #    Enum.sort(txns, fn txn1, txn2 ->
    #      cond do
    #        txn1. date == nil and txn2.date != nil -> true
    #        txn1. date != nil and txn2.date == nil -> false
    #        true -> Date.compare(txn1.date, txn2.date)
    #      end
    #    end)
    Enum.reverse(txns)
  end


  defp empty_transaction, do: List.duplicate("", 4)


  defp convert_to_rows(txn_list, max_row_index) do

    Enum.reduce(max_row_index..0, [], fn row_index, rows ->
      row = txn_list
            |> Enum.map(&Enum.at(&1, row_index))
            |> List.flatten

      [ row | rows ]
    end)
  end



  def build_ranges(rows, row) do
    ranges =
      Range.new(row + length(rows) - 1, row)
      |> Enum.reduce([], fn (row, acc) ->
        row_as_str = to_string(row)
        [["'XYZ'!A" <> row_as_str <> ":AO" <> row_as_str ] | acc]
      end)

    {ranges, rows}
  end
end
