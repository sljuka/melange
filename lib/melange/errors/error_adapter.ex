defmodule Melange.ErrorAdapter do
  alias Melange.ErrorMessages

  def adapt(result) do
    case result do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, adapt_changeset(changeset)}
      {:error, field, message} ->
        {:error, adapt_field_error(field, message)}
      res -> res
    end
  end

  def adapt_changeset(changeset) do
    %{
      message: "Unprocessible",
      error: Enum.map(
        changeset.errors,
        fn {field, detail} -> adapt_changeset_details(field, detail) end
      )
    }
  end

  defp adapt_changeset_details(field, {message, _keyword_list}) do
    %{
      field: field,
      short_message: ErrorMessages.to_short_message(message),
      message: ErrorMessages.to_long_message(message)
    }
  end

  defp adapt_field_error(field, message) do
    %{
      message: "Unprocessible",
      error: [%{
        field: field,
        short_message: ErrorMessages.to_short_message(message),
        message: ErrorMessages.to_long_message(message)
      }]
    }
  end
end
