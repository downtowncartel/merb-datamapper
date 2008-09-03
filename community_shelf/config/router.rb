Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  r.to(:controller => 'books') do |books|
    books.match(%r'/book/((?:\d{10})|(?:\d{13}))$').to(:action => 'isbn_lookup', :isbn => '[1]')

    books.match('/books', :method => 'post').to(:action => 'create')
    books.match('/books/new').to(:action => 'new').name(:new_book)

    books.match('/book/:slug').to(:action => 'show').name(:book)
    books.match('/books').to(:action => 'index')
    books.match('/books/:term').to(:action => 'index').name(:books)
  end

  r.to(:controller => 'dash') do |dash|
    dash.match('/').to(:action => 'index').name(:dash)
  end

  r.to(:controller => 'users') do |users|
    users.match('/signup', :method => :post).to(:action => 'create')
    users.match('/signup').to(:action => 'new').name(:signup)
  end

  r.to(:controller => 'sessions') do |sessions|
    sessions.match('/login/complete').to(:action => 'create').name(:complete_login)
    sessions.match('/login', :method => :post).to(:action => 'create')
    sessions.match('/login').to(:action => 'new').name(:login)
    sessions.match('/logout').to(:action => 'destroy').name(:logout)
  end
end