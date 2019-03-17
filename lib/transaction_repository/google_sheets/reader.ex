defmodule TransactionRepository.GoogleSheets.Reader do

  @enforce_keys [:index_to_category]
  defstruct @enforce_keys


  def row_reader(sheet) do
    fn -> GSS.Spreadsheet.read_rows(sheet, 25, 35, column_to: 40, pad_empty: true) end
  end


  def read_transactions(config, read_rows) do
    case read_rows.() do
      {:ok, rows} -> rows
                    |> Enum.flat_map(&to_transactions(&1, config.index_to_category, fn x -> x end))
                    |> Enum.to_list

      error       -> error
    end
  end


  defp to_transactions(row, index_to_category, date_fn) do
    row
    |> Enum.chunk_every(4)
    |> Enum.with_index
    |> Enum.map(fn {txn_data, index} -> {txn_data, index_to_category.(index)} end)
    |> Enum.map(&parse_transaction(&1, date_fn))
    |> Enum.reduce([], fn ({flag, txn}, acc) ->
      case flag do
        :ok     -> [txn|acc]
        :empty  -> acc
      end
    end)
    |> Enum.reverse
  end

  defp parse_transaction({txn_data, category}, date_fn) do
    {[description, day], amount_cols} = Enum.split(txn_data, 2)
    {owner, amount} = owner_amount_from(amount_cols)

    case owner do
      :none -> {:empty, nil}
      _     -> {:ok, transaction_from(description,
                                      date_fn.(day),
                                      category,
                                      owner,
                                      amount)}
    end
  end

  defp transaction_from(description, date, category, owner, amount) do
    txn = %Transaction{
      description: description,
      date: date,
      category: category,
      owner: owner
    }

    case category do
      :Income -> %{txn | credit: amount}
      _ -> %{txn | debit: amount}
    end
  end



  defp owner_amount_from([matt_amt, jessica_amt]) do
    cond do
      bit_size(matt_amt) > 0  -> {"Matt", Util.to_amount(matt_amt)}
      bit_size(jessica_amt) > 0  -> {"Jessica", Util.to_amount(jessica_amt)}
      true -> {:none, 0}
    end
  end
end
