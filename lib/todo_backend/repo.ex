defmodule TodoBackend.Repo do
  use Ecto.Repo,
    otp_app: :todo_backend,
    adapter: Ecto.Adapters.Postgres

    use Scrivener, page_size: 10
end
