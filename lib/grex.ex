defmodule Grex do
  @moduledoc """
  Goodreads API Client. Currently only a subset of APIs are implemented.
  """

  defdelegate new(key), to: Grex.Client

  defdelegate get_reviews(client, gr_id, shelf, sort, search, order, page, per_page),
    to: Grex.Reviews
end
