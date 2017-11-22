defmodule DDWRT.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ddwrt,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "A library for interacting with routes running DD-WRT"
  end

  defp package do
    [
      maintainers: ["Derek Schaefer"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/derek-schaefer/ddwrt"}
    ]
  end
end
