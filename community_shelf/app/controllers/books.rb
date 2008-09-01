class Books < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    render
  end

  def show(slug)
    @book = Book.first(:slug => slug) || raise(NotFound, :book_slug => slug)

    display @book
  end
end
