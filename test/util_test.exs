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
end
