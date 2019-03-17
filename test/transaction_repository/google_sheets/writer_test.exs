defmodule TransactionRepository.GoogleSheets.WriterTest do
  use ExUnit.Case, async: true

  alias TransactionRepository.GoogleSheets.Writer, as: Writer

  setup do
    txn1 = %Transaction{
      description: "txn description 1",
      date: "10/30/2017",
      owner: "Meg",
      category: :Bills,
      debit: 0,
      credit: 0
    }
    txn2 = %Transaction{
      description: "txn description 2",
      date: "10/31/2017",
      owner: "Chris",
      category: :Bills,
      debit: 0,
      credit: 0
    }
    txn3 = %Transaction{
      description: "txn description 3",
      date: "11/1/2017",
      owner: "Brian",
      category: :Bills,
      debit: 0,
      credit: 0
    }
    
    %{
      transaction1: txn1,
      transaction2: txn2,
      transaction3: txn3,      
      transaction_list: [txn1, txn2, txn3]
    }
  end


end
