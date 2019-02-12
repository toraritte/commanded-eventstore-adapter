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
  defp deps do
    [
      # 2019-01-24_1359 TODO !!!
      @doc """
      Figure out whether Commanded is needed as dependency
      or  not. Overwrote  previous  history when  rebasing
      `upstream/master`,  and  didn't pay  attention,  and
      there  was a  commit  called  "Remove commanded  and
      eventstore from deps"...
      {:commanded, "~> 0.18", runtime: Mix.env() == :test},

      2019-02-12_1332 NOTE
      The  `runtime: Mix.env()  ==  :test`  part has  been
      re-added,  otherwise  both   this  and  the  project
      pulling Commanded in would fail to get deps.

      Was  also  thinking  about  where  the  `EventStore`
      behaviour should reside, and  came to the conclusion
      that this is  good as it is, and  I was overthinking
      it to  move it to `commanded/eventstore`.  Why would
      the  latter  need the  behaviour  when  it's API  is
      explicitly set out?
      """
      {:commanded,
        github:   "toraritte/commanded",
        branch:   "make-application-more-idiomatic-2",
        runtime: Mix.env() == :test,
      },
      {:eventstore, github: "toraritte/eventstore", branch: "master"},

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
