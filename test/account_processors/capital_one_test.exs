defmodule AccountProcessors.CapitalOneTest do
  use ExUnit.Case, async: true

  alias AccountProcessors.CapitalOne, as: CapitalOne

  setup do
    owner_name = "Stewie"
    txn_date = "10/30/2017"
    description = "a description"

    %{
      name: owner_name,
      txn_date: txn_date,
      description: description,
      expected_txn: %Transaction{
        description: description,
        date: txn_date,
        owner: owner_name,
        category: :Bills,
        debit: 0,
        credit: 0
      }
    }
  end


  describe "map_transaction_for returns a function that will map to the provided owner" do

    test "will set proper values for a debit", context do
      map_transaction = CapitalOne.map_transaction_for(context.name)
      record = [:ignore, context.txn_date, :ignore, :ignore, context.description, :a_category, "123.45", ""]
      mapped_txn = %{ context.expected_txn | debit: 123.45 }

      assert map_transaction.(record) == {:ok, mapped_txn}
    end

    test "will set proper values for a credit", context do
      map_transaction = CapitalOne.map_transaction_for(context.name)
      record = [:ignore, context.txn_date, :ignore, :ignore, context.description, :a_category, "", "67.89"]
      mapped_txn = %{ context.expected_txn | credit: 67.89 }

      assert map_transaction.(record) == {:ok, mapped_txn}
    end

    test "will return an error when there is no debit or credit", context do
      map_transaction = CapitalOne.map_transaction_for(context.name)
      record = [:ignore, context.txn_date, :ignore, :ignore, context.description, :a_category, "", ""]

      assert map_transaction.(record) == {:error, "No transaction value: " <> inspect(record)}
    end

    test "will return an error when there is no a malformed debit", context do
      map_transaction = CapitalOne.map_transaction_for(context.name)
      record = [:ignore, context.txn_date, :ignore, :ignore, context.description, :a_category, "malformed debit", ""]

      assert map_transaction.(record) == {:error, "Can't convert malformed debit: " <> inspect(record)}
    end

    test "will return an error when there is no a malformed credit", context do
      map_transaction = CapitalOne.map_transaction_for(context.name)
      record = [:ignore, context.txn_date, :ignore, :ignore, context.description, :a_category, "", "malformed credit"]

      assert map_transaction.(record) == {:error, "Can't convert malformed credit: " <> inspect(record)}
    end
  end

end
