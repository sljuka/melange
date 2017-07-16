defmodule Melange.GraphQL.Adapters.ErrorAdapter do
  def adapt(result) do
    case result do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, adapt_changeset(changeset)}
      val -> val
    end
  end

  def adapt_changeset(changeset) do
    %{
      message: "Unprocessible",
      error: Enum.map(
        changeset.errors,
        fn {field, detail} -> Map.put(%{}, field, adapt_changeset_details(detail)) end
      )
    }
  end

  defp adapt_changeset_details({message, keyword_list}) do
    %{
      message: message,
      details: Enum.into(keyword_list, %{})
    }
  end
end
