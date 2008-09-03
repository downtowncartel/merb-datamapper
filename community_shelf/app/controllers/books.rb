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

  def isbn_lookup(isbn)
    isbn = ISBN_Tools.isbn10_to_isbn13(self.isbn) if isbn.size == 10

    @book = Book.first(:isbn => isbn) || raise(NotFound, :isbn => isbn)

    redirect url(:book, :slug => @book.slug)
  end

  def new
    @message = request.message
    @book = Book.new

    display @book
  end

  def create(book)
    @book = Book.new(book.merge(:owner => session.user))

    if @book.save
      redirect(url(:new_book), :message => "\"#{@book.short_title}\" has been added")
    else
      display @book, "books/new"
    end
  end
end
