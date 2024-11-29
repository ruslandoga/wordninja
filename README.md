Quick and dirty port of https://github.com/keredson/wordninja

Needs more work to be usable:
- improve performance, use ideas from https://github.com/stephantul/wordninja2
- integrate with wordfreq
- fuzzy matching

```elixir
Mix.install([{:wordninja, github: "ruslandoga/wordninja"}])

# suggestion: load in a separate process for quicker garbage collection
model = Wordninja.load()

Wordninja.split(model, "thisistest")
#=> ["this", "is", "test"]

Wordninja.split(model, "settingsbillingsubscription")
#=> ["settings", "billing", "subscription"]

Wordninja.split(model, "settbillsub")
#=> ["sett", "bill", "sub"]
```
