defmodule UtilTest do
  use ExUnit.Case, async: true

  import Util

  describe "curry" do
    test "curries the provided function" do
      adder = curry(fn x, y, z -> x + y + z end)

      add2 = adder.(2)
      add9 = add2.(7)
      assert add9.(10) == 19

      assert adder.(4).(-1).(13) == 16
    end

    test "calling curry on a function that takes no arguments results in the function's value" do
      assert :my_value = curry(fn -> :my_value end)
    end
  end


  describe "typeof" do
    test "returns the type of a variable" do
      assert "atom" == typeof(:an_atom)
      assert "boolean" == typeof(false)
      assert "float" == typeof(123.45)
      assert "function" == typeof(fn x -> x + 1 end)
      assert "integer" == typeof(2)
      assert "list" == typeof(["a", "list"])
      assert "map" == typeof(%{key: :value})
      assert "nil" == typeof(nil)
      assert "pid" == typeof(spawn fn -> nil end)
      assert "port" == typeof(Port.open({:spawn, "test"}, []))
      assert "tuple" == typeof({1, "tuple", :please})
      assert "binary" == typeof("a bitstring divisible by 8")
      assert "bitstring" == typeof(<<1 :: size(7)>>)
    end
  end


  describe "to_amount" do
    test "converts string value to integer value in cents" do
      assert 1000 == to_amount("10.00")
      assert 4567 == to_amount("45.67")
      assert 1000 == to_amount("10.0")
      assert 9900 == to_amount("99")
      assert 15 == to_amount("0.15")
      assert 2 == to_amount("0.02")
    end
  end

  describe "format_amount" do
    test "converts integer value to formatted string" do
      assert "10.00" == format_amount(1000)
      assert "45.67" == format_amount(4567)
      assert "0.15" == format_amount(15)
      assert "0.02" == format_amount(2)
    end
  end

end
