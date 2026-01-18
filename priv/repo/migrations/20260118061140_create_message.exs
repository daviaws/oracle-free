defmodule HelloPhoenix.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  @string_size 20
  @name_string_size 30

  def change do
    create table(:message) do
      add :from, :string, size: @string_size, null: false        # wa_id
      add :from_name, :string, size: @name_string_size, null: false
      add :to, :string, size: @string_size, null: false          # phone_number (display_phone_number ou phone_number_id)
      add :to_number_id, :string, size: @string_size, null: false

      add :content, :text, null: false
      add :type, :string, size: @string_size, null: false

      add :sent_at, :utc_datetime, null: false
      add :received_at, :utc_datetime, null: false

      add :source, :string, size: @string_size, null: false      # "whatsapp"
      add :external_id, :string, size: @string_size, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:message, [:external_id])
    create index(:message, [:from])
    create index(:message, [:sent_at])
  end
end
