defmodule Util do

  def curry(function) do
    { _, arity} = :erlang.fun_info(function, :arity)

    curry(function, arity, [])
  end

  def curry(function, 0, args), do: apply(function, Enum.reverse args)

  def curry(function, arity, args) do
    fn arg -> curry(function, arity - 1, [arg | args]) end
  end


  def typeof(value) do
    cond do
      is_boolean(value) -> "boolean"
      is_float(value) -> "float"
      is_function(value) -> "function"
      is_integer(value) -> "integer"
      is_list(value) -> "list"
      is_map(value) -> "map"
      is_nil(value) -> "nil"
      is_pid(value) -> "pid"
      is_port(value) -> "port"
      is_tuple(value) -> "tuple"
      is_binary(value) -> "binary"
      is_bitstring(value) -> "bitstring"
      is_atom(value) -> "atom"
    end
  end

end
