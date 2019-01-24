### 2018-10-30_2231 NOTE

Removing  `eventstore`  because   it  is  listed  in
`deps`  therefore  it   is  added  automatically  to
`:applications`. This  app also  does not  start any
processes,  it  just  maps  behaviour  callbacks  to
EventStore functions. EventStore  should be added to
a projects `:extra_applications` anyway.

https://hexdocs.pm/mix/Mix.Tasks.Compile.App.html

### 2018-10-30_2231 NOTE

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

### 2018-10-31_0833 NOTE

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

#### Here's a radical idea:

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

---------------------

# EventStore adapter for Commanded

Use the PostgreSQL-based [EventStore](https://github.com/commanded/eventstore) with [Commanded](https://github.com/commanded/commanded).

[Changelog](CHANGELOG.md)

MIT License

[![Build Status](https://travis-ci.com/commanded/commanded-eventstore-adapter.svg?branch=master)](https://travis-ci.com/commanded/commanded-eventstore-adapter)

## Getting started

The package can be installed from hex as follows.

1. Add `commanded_eventstore_adapter` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:commanded_eventstore_adapter, "~> 0.5"}]
    end
    ```

2. Include `:eventstore` in the list of extra applications to start in `mix.exs`:

    ```elixir
    def application do
      [
        extra_applications: [
          :logger,
          :eventstore,
        ],
      ]
    end
    ```

3. Configure Commanded to use the `Commanded.EventStore.Adapters.EventStore` adapter:

    ```elixir
    config :commanded,
      event_store_adapter: Commanded.EventStore.Adapters.EventStore
    ```

4. Configure the `eventstore` in each environment's mix config file (e.g. `config/dev.exs`), specifying usage of the included JSON serializer:

    ```elixir
    config :eventstore, EventStore.Storage,
      serializer: Commanded.Serialization.JsonSerializer,
      username: "postgres",
      password: "postgres",
      database: "eventstore_dev",
      hostname: "localhost",
      pool_size: 10
    ```

5. Create the `eventstore` database and tables using the `mix` task:

    ```console
    $ mix do event_store.create, event_store.init
    ```
