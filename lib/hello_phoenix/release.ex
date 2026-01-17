defmodule HelloPhoenix.Release do
  @app :hello_phoenix

  def migrate do
    for repo <- repos() do
      repo.__adapter__().storage_up(repo.config())
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  defp repos do
    Application.load(@app)
    Application.get_env(@app, :ecto_repos, [])
  end
end
