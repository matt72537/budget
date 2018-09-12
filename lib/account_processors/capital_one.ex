defmodule AccountProcessors.CapitalOne do
  @moduledoc false

  require Transaction

  def map_transaction_for(owner) do
    fn ([_, txn_date, _, _, description, category, debit, credit] = record) ->
      txn = %Transaction{
        description: description,
        date: txn_date,
        category: categorize(category, description),
        owner: owner
      }


      case set_amount(txn, debit, credit) do
        {:error, message} -> {:error, message <> ": " <> inspect(record)}
        ok -> ok
      end
    end
  end


  defp set_amount(txn, debit, credit) do
    case transaction_amount(debit, credit) do
      {:debit, amount} -> {:ok, %{txn | debit: amount }}
      {:credit, amount} -> {:ok, %{txn | credit: amount }}
      error -> error
    end
  end

  defp transaction_amount(debit, credit) do
    cond do
      bit_size(debit) > 0  -> convert_amount(:debit, debit)
      bit_size(credit) > 0 -> convert_amount(:credit, credit)
      true -> {:error, "No transaction value"}
    end
  end


  defp convert_amount(type, amount) do
    case Float.parse(amount) do
      :error -> {:error, "Can't convert " <> to_string(amount)}
      {value, _} -> {type, value}
    end
  end


  defp categorize(_category, _description) do
    :Bills
  end

end
