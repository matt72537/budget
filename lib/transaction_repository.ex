defmodule TransactionRepository do
  @moduledoc false

  import TransactionRepository.GoogleSheets.Reader, only: [read_transactions: 2, row_reader: 1]
  import TransactionRepository.GoogleSheets.Writer, only: [write_transactions: 3, row_writer: 1]

  @categories [:Income, :Bills, :Groceries, :House, :Medical, :Miscellaneous, :Savings, :Disc, :Entertainment, :Other]

  def load_spreasheet() do
    {:ok, pid} = GSS.Spreadsheet.Supervisor.spreadsheet("1IJ3a3duMVoQjDRkFYtj_1uGYBGAHZqJCSdHYh6fhgmE")
    pid
  end


  def get_transactions(sheet) do
    config = %TransactionRepository.GoogleSheets.Reader{
      index_to_category: &Enum.at(@categories, &1)
    }

    read_transactions(config, row_reader(sheet))
  end

  def set_transactions(sheet, transactions) do
    config = %TransactionRepository.GoogleSheets.Writer{
      categories: @categories,
      category_to_index: &Enum.find_index(@categories, fn x -> x == &1 end)
    }

    write_transactions(config, transactions, row_writer(sheet))
  end

end
