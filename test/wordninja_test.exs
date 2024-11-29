defmodule WordninjaTest do
  use ExUnit.Case

  setup_all do
    {:ok, model: Wordninja.load()}
  end

  test "it works", %{model: model} do
    assert Wordninja.split(model, "thisistest and thisaswell") == [
             "this",
             "is",
             "test",
             "and",
             "this",
             "as",
             "well"
           ]
  end
end
