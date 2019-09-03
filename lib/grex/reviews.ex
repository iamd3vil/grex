defmodule Grex.Reviews do
  @moduledoc """
  Contains functions related to reviews of a user
  """
  import SweetXml

  @base_url "https://www.goodreads.com/review/list"

  @spec get_reviews(
          Grex.Client.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t()
        ) :: {:ok, map} | {:error, any()}
  def get_reviews(client, gr_id, shelf, sort, search, order, page, per_page) do
    timeout = Application.get_env(:grex, :timeout, 60000)

    @base_url
    |> URI.parse()
    |> Map.put(
      :query,
      URI.encode_query(%{
        v: 2,
        key: client.key,
        id: gr_id,
        shelf: shelf,
        sort: sort,
        search: search,
        order: to_string(order),
        page: page,
        per_page: per_page
      })
    )
    |> URI.to_string()
    |> Mojito.get([], timeout: timeout)
    |> case do
      {:ok, %{body: body, status_code: 200}} ->
        {:ok, decode_xml_response(body)}

      {:ok, %{status_code: code}} ->
        {:error, "error from goodreads: #{code}"}

      error ->
        error
    end
  end

  defp decode_xml_response(resp) do
    resp
    |> xpath(
      ~x"//reviews/review/book"l,
      id: ~x"./isbn/text()"s,
      link: ~x"./link/text()"s,
      publisher: ~x"./publisher/text()"s,
      publication_day: ~x"./publication_day/text()"s,
      publication_year: ~x"./publication_year/text()"s,
      publication_month: ~x"./publication_month/text()"s,
      average_rating: ~x"./average_rating/text()"s,
      ratings_count: ~x"./ratings_count/text()"s,
      description: ~x"./description/text()"s,
      read_at: ~x"./read_at/text()"s,
      date_added: ~x"./date_added/text()"s,
      date_updated: ~x"./date_updated/text()"s,
      authors: [
        ~x"./authors/author"l,
        id: ~x"./id/text()"s,
        name: ~x"./name/text()"s,
        link: ~x"./link/text()"s,
        average_rating: ~x"./average_rating/text()"s,
        ratings_count: ~x"./ratings_count/text()"s,
        text_reviews_count: ~x"./text_reviews_count/text()"s
      ]
    )
  end
end
