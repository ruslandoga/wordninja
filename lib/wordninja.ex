defmodule Wordninja do
  @moduledoc """
  Elixir port of keredson/wordninja.
  """

  def default_vocabulary do
    Application.app_dir(:wordninja, "priv/wordninja_words.txt")
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def load(words \\ default_vocabulary()) do
    words_count = length(words)

    wordcost =
      words
      |> Enum.with_index()
      |> Map.new(fn {word, i} ->
        {word, :math.log((i + 1) * :math.log(words_count))}
      end)

    maxword = words |> Enum.max_by(&byte_size/1) |> byte_size()

    %{wordcost: wordcost, maxword: maxword}
  end

  def split(model, text) do
    all =
      for text <- String.split(text) do
        backtrack(model, cost(model, text), text)
      end

    List.flatten(all)
  end

  defp cost(model, text) do
    %{wordcost: wordcost, maxword: maxword} = model
    cost(wordcost, maxword, text, _cost_acc = [0], _i = 1)
  end

  defp cost(wordcost, maxword, text, cost_acc, i) do
    {c, _k} = best_match(wordcost, maxword, text, cost_acc, i)
    cost_acc = [c | cost_acc]

    if byte_size(text) == i do
      :lists.reverse(cost_acc)
    else
      cost(wordcost, maxword, text, cost_acc, i + 1)
    end
  end

  defp backtrack(model, cost, text) do
    %{wordcost: wordcost, maxword: maxword} = model
    [_ | cost] = :lists.reverse(cost)
    backtrack(wordcost, maxword, text, cost, _out_acc = [], _i = byte_size(text))
  end

  defp backtrack(wordcost, maxword, text, cost, out_acc, i) when i > 0 do
    {_c, k} = best_match(wordcost, maxword, text, cost, i)
    new_token = binary_slice(text, (i - k)..(i - 1))
    cost = Enum.drop(cost, k)
    backtrack(wordcost, maxword, text, cost, [new_token | out_acc], i - k)
  end

  defp backtrack(_wordcost, _maxword, _text, _cost, out_acc, _i) do
    out_acc
  end

  defp best_match(wordcost, _maxword, text, candidates, i) do
    Enum.min(matches(wordcost, text, candidates, i, _k = 0))
  end

  defp matches(wordcost, text, [c | candiates], i, k) do
    subword = String.downcase(binary_slice(text, (i - k - 1)..(i - 1)))
    new = {c + Map.get(wordcost, subword, 999_999), k + 1}
    [new | matches(wordcost, text, candiates, i, k + 1)]
  end

  defp matches(_wordcost, _text, [], _i, _k) do
    []
  end
end
