defmodule TransactionRepository.GoogleSheets.ReaderTest do
  use ExUnit.Case, async: true

  alias TransactionRepository.GoogleSheets.Reader, as: Reader

  setup do
    matt_bill = %Transaction{
      description: "bill description 1",
      date: "1/1/2019",
      owner: "Matt",
      category: :Bills,
      debit: 100,
      credit: 0
    }
    matt_bill2 = %Transaction{
      description: "bill description 1.2",
      date: "1/21/2019",
      owner: "Matt",
      category: :Bills,
      debit: 199,
      credit: 0
    }
    jess_bill = %Transaction{
      description: "bill description 2",
      date: "1/2/2019",
      owner: "Jessica",
      category: :Bills,
      debit: 200,
      credit: 0
    }
    matt_groceries = %Transaction{
      description: "groceries description 1",
      date: "1/4/2019",
      owner: "Matt",
      category: :Groceries,
      debit: 110,
      credit: 0
    }
    jess_groceries = %Transaction{
      description: "groceries description 2",
      date: "1/5/2019",
      owner: "Jessica",
      category: :Groceries,
      debit: 210,
      credit: 0
    }
    matt_income = %Transaction{
      description: "income description 1",
      date: "1/7/2019",
      owner: "Matt",
      category: :Income,
      debit: 0,
      credit: 101
    }
    matt_income2 = %Transaction{
      description: "income description 1.2",
      date: "1/27/2019",
      owner: "Matt",
      category: :Income,
      debit: 0,
      credit: 991
    }
    jess_income = %Transaction{
      description: "income description 2",
      date: "1/8/2019",
      owner: "Jessica",
      category: :Income,
      debit: 0,
      credit: 201
    }


    %{
      categories: [:Bills, :Groceries, :Income],
      txn_matt_bill: matt_bill,
      txn_jess_bill: jess_bill,
      txn_matt_groceries: matt_groceries,
      txn_jess_groceries: jess_groceries,
      txn_matt_income: matt_income,
      txn_jess_income: jess_income,
      txn_matt_bill2: matt_bill2,
      txn_matt_income2: matt_income2,
      rows: [
        [ matt_bill.description, matt_bill.date, Util.format_amount(matt_bill.debit), "",
          matt_groceries.description, matt_groceries.date, Util.format_amount(matt_groceries.debit), "",
          matt_income.description, matt_income.date, Util.format_amount(matt_income.credit), ""
        ],
        [ jess_bill.description, jess_bill.date, "", Util.format_amount(jess_bill.debit),
          jess_groceries.description, jess_groceries.date, "", Util.format_amount(jess_groceries.debit),
          jess_income.description, jess_income.date, "", Util.format_amount(jess_income.credit)
        ],
        [ matt_bill2.description, matt_bill2.date, Util.format_amount(matt_bill2.debit), "",
          "", "", "", "",
          matt_income2.description, matt_income2.date, Util.format_amount(matt_income2.credit), ""
        ]
      ]

      # rows: [ [ matt_bill.description, matt_bill.date, Util.format_amount(matt_bill.debit), "" ] ]
    }
  end


  test "map rows to transactions", context do
    config = %{
      index_to_category: &Enum.at(context.categories, &1)
    }

    transactions = Reader.read_transactions(config, fn -> {:ok, context.rows} end)

    assert transactions == [
      context.txn_matt_bill,
      context.txn_matt_groceries,
      context.txn_matt_income,
      context.txn_jess_bill,
      context.txn_jess_groceries,
      context.txn_jess_income,
      context.txn_matt_bill2,
      context.txn_matt_income2
    ]
  end
end
