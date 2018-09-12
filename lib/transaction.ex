defmodule Transaction do
  @moduledoc false

  defstruct owner: nil,
            description: "",
            date: nil,
            category: nil,
            debit: 0,
            credit: 0

  alias NimbleCSV.RFC4180, as: CSV

  def load_transactions(map_txn) do
    "/Users/mattsales/Downloads/2018-08-26_transaction_download.csv"
    |> File.stream!
    |> CSV.parse_stream
    |> Stream.map(map_txn)
    |> Enum.each(&process_transaction/1)
  end


  def process_transaction(transaction) do
    case transaction do
      {:ok, txn} -> txn |> write_transaction
      {:error, message} -> message
    end
  end


  def write_transaction(txn) do
    IO.puts("HOLA " <> to_string(inspect(txn)))
  end

end
