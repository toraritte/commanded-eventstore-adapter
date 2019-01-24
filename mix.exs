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
  NOTE 2018-10-30_2231

  Removing  `eventstore`  because   it  is  listed  in
  `deps`  therefore  it   is  added  automatically  to
  `:applications`. This  app also  does not  start any
  processes,  it  just  maps  behaviour  callbacks  to
  EventStore functions. EventStore  should be added to
  a projects `:extra_applications` anyway.

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

  NOTE 2018-10-31_0833

    Adding   back  `eventstore`   as  this   adapter  is
    basically only  a wrapper  around EventStore  and it
    uses EventStore's  structs directly,  therefore they
    need to be present.

    => In this case, why not make it an application that
       automatically adds EventStore  to the supervision
       tree to any project that includes this adapter in
       its deps?
      \
       I  think  it would  be  a  bad idea  wrapping  an
       application  into  another  application  just  to
       maintain conformity.

    Here's a radical idea:
    ----------------------
    This   `commanded/eventstore`    vs   Greg   Young's
    EventStore   situation  is   exactly  the   same  as
    with  `Phoenix.PubSub`:  there   are  two  adapters,
    an   internal   (`PG2`)    and   an   external   one
    (`Redis`).   The   `phoenix_pubsub`  repo   contains
    the  adapter  specification  (`Phoenix.PubSub`)  and
    internal  adapter implementation  (`PG2`), which  is
    basically  the  PubSub  implementation  adhering  to
    the specs  in the same  repo. `phoenix_pubsub_redis`
    however    is   a    completely   different    repo,
    including   `phoenix_pubsub`   as  its   dependency,
    and  it  indeed  is   a  translation  layer  between
    the   Redis  service   and  Phoenix.   Meanwhile  it
    draws   on  several   `phoenix_pubsub`  modules   to
    avoid  implementing  common functionality  (such  as
    `Phoenix.PubSub.LocalSupervisor`).

    Long  story  short,  Commanded   also  has  its  own
    EventStore  in  a separate  repo,  but  it would  be
    natural if  it would  "just" conform to  the adapter
    spec, and the Extreme adapter would be the bridge to
    GY's EventStore. This is of course more nuanced than
    that, but will figure it out.

    Until  then,  all  remains the  same:  include  this
    adapter  in  a  project   and  add  `eventstore`  to
    `:extra_applications`.
  """
  defp deps do
    [
      # 2019-01-24_1359 TODO !!!
      # Figure out whether Commanded is needed as dependency
      # or  not. Overwrote  previous  history when  rebasing
      # `upstream/master`,  and  didn't pay  attention,  and
      # there  was a  commit  called  "Remove commanded  and
      # eventstore from deps"...
      # {:commanded, "~> 0.18", runtime: Mix.env() == :test},
      {:commanded,
        github:   "toraritte/commanded",
        branch:   "make-application-more-idiomatic-2",
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
