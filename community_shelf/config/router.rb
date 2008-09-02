Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  r.to(:controller => 'books') do |books|
    books.match(%r'/book/((?:\d{10})|(?:\d{13}))$').to(:action => 'isbn_lookup', :isbn => '[1]')
  end
  
  r.to(:controller => 'books') do |books|
    books.match('/book/:slug').to(:action => 'show').name(:book)
    books.match('/books').to(:action => 'index')
    books.match('/books/:term').to(:action => 'index').name(:books)
  end
end