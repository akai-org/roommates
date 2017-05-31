defmodule Roommates.Repo.Migrations.AddRoommatesTable do
  use Ecto.Migration

  def change do
    create table(:rooms_roommates) do
      add :user_id, references(:users)
      add :room_id, references(:rooms_rooms)
      timestamps
    end

    create unique_index(:rooms_roommates, [:user_id, :room_id])
  end
end
