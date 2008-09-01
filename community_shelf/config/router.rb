Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  r.to(:controller => 'books') do |books|
    books.match('/book/:slug').to(:action => 'show').name(:book)
    books.match('/books/:term').to(:action => 'index').name(:books)
    books.match('/books').to(:action => 'index').name(:books)
  end
end