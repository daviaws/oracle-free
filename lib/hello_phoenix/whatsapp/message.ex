defmodule HelloPhoenix.Whatsapp.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :from,
    :from_name,
    :to,
    :to_number_id,
    :content,
    :type,
    :sent_at,
    :received_at,
    :source,
    :external_id
  ]

  @string_size 20
  @name_string_size 30

  require Logger

  schema "message" do
    field(:from, :string)
    field(:from_name, :string)
    field(:to, :string)
    field(:to_number_id, :string)
    field(:content, :string)
    field(:type, :string)

    field(:sent_at, :utc_datetime)
    field(:received_at, :utc_datetime)

    field(:source, :string)
    field(:external_id, :string)

    timestamps(type: :utc_datetime)
  end

  def changeset(message \\ %__MODULE__{}, attrs) do
    message
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:from, max: @string_size)
    |> validate_length(:from_name, max: @name_string_size)
    |> validate_length(:to, max: @string_size)
    |> validate_length(:to_number_id, max: @string_size)
    |> validate_length(:type, max: @string_size)
    |> validate_length(:source, max: @string_size)
    |> validate_length(:external_id, max: @string_size)
    |> unique_constraint(:external_id)
  end

  def parse(message \\ %__MODULE__{}, args, received_at) do
    with {:ok, attrs} <- to_attrs(args, received_at) do
      {:ok, changeset(message, attrs)}
    end
  end

  defp to_attrs(%{
        "entry" => [
          %{
            "changes" => [
              %{
                "field" => "messages",
                "value" => %{
                  "contacts" => [%{"profile" => %{"name" => from_name}, "wa_id" => from}],
                  "messages" => [
                    %{
                      "from" => _from,
                      "id" => _message_id,
                      "text" => %{"body" => content},
                      "timestamp" => timestamp,
                      "type" => type
                    }
                  ],
                  "messaging_product" => source,
                  "metadata" => %{
                    "display_phone_number" => to,
                    "phone_number_id" => to_number_id
                  }
                }
              }
            ],
            "id" => hook_id
          }
        ],
        "object" => "whatsapp_business_account"
  }, received_at) do
    {:ok, %{
      from: from,
      from_name: from_name,
      to: to,
      to_number_id: to_number_id,
      content: content,
      type: type,
      external_id: hook_id,
      source: source,
      sent_at: unix_to_utc(timestamp),
      received_at: received_at
    }}
  end

  defp to_attrs(_args, _received_at) do
    Logger.error("[Whatsapp.Message] has no match in args formats")
    {:error, :no_match}
  end

  defp unix_to_utc(timestamp) when is_binary(timestamp) do
    String.to_integer(timestamp)
    |> DateTime.from_unix!()
  end
end
