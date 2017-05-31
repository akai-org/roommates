defmodule Roommates.Repo.Migrations.CreateRoommates.Rooms.Room do
  use Ecto.Migration

  def change do
    create table(:rooms_rooms) do
      add :name, :string
      add :admin_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:rooms_rooms, [:admin_id])
  end
end
