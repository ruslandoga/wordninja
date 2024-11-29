Quick and dirty port of https://github.com/keredson/wordninja

Needs more work to be usable:
- improve performance, use ideas from https://github.com/stephantul/wordninja2/tree/main
- integrate with wordfreq
- fuzzy matching with trigrams

```elixir
Mix.install([{:wordninja, github: "ruslandoga/wordninja"}])

# suggestion: load in a separate process for quicker garbage collection
model = Wordninja.load()

"this is test" = Wordninja.split(model, "thisistest")
```