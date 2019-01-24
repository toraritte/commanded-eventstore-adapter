defmodule Commanded.EventStore.Adapters.EventStore.Mixfile do
  use Mix.Project

  @version "0.5.0"

  def project do
    [
      app: :commanded_eventstore_adapter,
      version: @version,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      consolidate_protocols: Mix.env() != :test,
      description: description(),
      docs: docs(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  """
  Removing  `eventstore`  because   it  is  listed  in
  `deps`   therefore   it   is   added   automatically
  to  `:applications`.   Although  this  app   is  not
  supervised.

  https://hexdocs.pm/mix/Mix.Tasks.Compile.App.html
  """
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test) do
    [
      "deps/commanded/test/event_store",
      "deps/commanded/test/support",
      "lib",
      "test/support"
    ]
  end

  defp elixirc_paths(_), do: ["lib"]

  """
  NOTE 2018-10-30_2231

  + Remove Commanded as a dependency, see issue #1.

    => Maybe adding it as a test dependency?

  + Also removing EventStore.

    I  am  biased  toward  more  explicit  configuration
    and the  `EventStore` application will  be available
    in   a   project,    therefore   the   mappings   in
    `./lib/event_store_adapter.ex` will work.

    => Test dependency?

  + The `Mox` idea seems to be  a nice approach as a 3rd
    option to the ones mentioned in issue #1. Explore it
    further.
  """
  defp deps do
    [
      {:commanded, "~> 0.18", runtime: Mix.env() == :test},
      {:eventstore, "~> 0.16"},

      # Optional dependencies
      {:jason, "~> 1.1", optional: true},

      # Build & test tools
      {:ex_doc, "~> 0.19", only: :dev},
      {:mix_test_watch, "~> 0.9", only: :dev},
      {:mox, "~> 0.4", only: :test}
    ]
  end

  defp description do
    """
    EventStore adapter for Commanded
    """
  end

  defp docs do
    [
      main: "Commanded.EventStore.Adapters.EventStore",
      canonical: "http://hexdocs.pm/commanded_eventstore_adapter",
      source_ref: "v#{@version}"
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*"
      ],
      maintainers: ["Ben Smith"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/commanded/commanded-eventstore-adapter",
        "Docs" => "https://hexdocs.pm/commanded_eventstore_adapter/"
      }
    ]
  end
end
