# XTurn Membrane

Adds source and sink hooks to the XTurn server for use with Membrane elements.

THIS IS CURRENTLY A WORK IN PROGRESS

## Installation

Add the following to the XTurn `mix.exs` files list of dependencies.

```elixir
def deps do
  [
    ...
    {:xturn_membrane, git: "https://github.com/xirsys/xturn-membrane"}
  ]
end
```

Then, add `:xturn_membrane` to the list of applications.

```elixir
  def application() do
    [
      applications: [:crypto, :sasl, :logger, :ssl, :xmerl, :exts, :xturn_membrane],
```
