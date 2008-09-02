class Books < Application

  def index(term = "a", page = 1, per_page = 5)
    @term = term
    @books, @pagination_info = Book.by_catalog(term).paginate(page.to_i, per_page.to_i)

    raise NotFound if @pagination_info[:count] == 0

    display @books
  end

  def show(slug)
    @book = Book.first(:slug => slug) || raise(NotFound, :book_slug => slug)

    display @book
  end
end
