defmodule Xirsys.XTurn.Membrane.MixProject do
  use Mix.Project

  def project do
    [
      app: :xturn_membrane,
      version: "0.1.0",
      elixir: "~> 1.6.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Membrane source and sink for the XTurn server.",
      source_url: "https://github.com/xirsys/xturn-membrane",
      homepage_url: "https://xturn.me",
      package: package(),
      docs: [
        extras: ["README.md"],
        main: "readme"
      ]
    ]
  end

  def application do
    [mod: {Xirsys.XTurn.Membrane.Supervisor, []}, extra_applications: [:logger]]
  end

  defp deps do
    [
      {:membrane_core, "~> 0.3"}
    ]
  end

  defp package do
    %{
      maintainers: ["Jahred Love"],
      licenses: ["Apache 2.0"],
      organization: ["Xirsys"],
      links: %{"Github" => "https://github.com/xirsys/xturn-membrane"}
    }
  end
end
