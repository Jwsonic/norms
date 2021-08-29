defmodule Norms do
  @moduledoc """
  Convinience functions and macros for working with Norm.
  """
  import Norm

  defmacro result(ok_predicate, error_predicate \\ nil) do
    error_predicate = error_predicate || quote do: spec(is_binary())

    quote do
      one_of([
        {:ok, unquote(ok_predicate)},
        {:error, unquote(error_predicate)}
      ])
    end
  end

  def simple_result do
    one_of([
      :ok,
      {:error, spec(is_binary())}
    ])
  end

  defmacro allow_nil(predicate) do
    quote do
      one_of([
        spec(is_nil()),
        unquote(predicate)
      ])
    end
  end

  def any_ do
    spec(fn _ -> true end)
  end

  def fun_with_arity(arity) when is_number(arity) do
    spec(
      is_function() and
        fn fun ->
          :erlang.fun_info(fun, :arity) == {:arity, arity}
        end
    )
  end

  def int_or_float do
    spec(is_integer() or is_float())
  end

  defmacro __using__(_args) do
    quote do
      use Norm

      import Norm
      import Norms
    end
  end
end
