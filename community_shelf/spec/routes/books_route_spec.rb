require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe "The :books named route" do
  it "should map url(:books) to '/books/'" do
    url(:books).should == '/books/'
  end

  it "should map url(:books, :term => 'z') to '/books/z'" do
    url(:books, :term => 'z').should == '/books/z'
  end

  it "should route GET '/books' to Books#index" do
    request_to('/books', :get).should route_to(Books, :index)
  end

  it "should route GET '/books/t' to Books#index with {:term => 't'}" do
    request_to('/books/t').should route_to(Books, :index).with(:term => 't')
  end
end

describe "The :book named route" do
  it "should map url(:book, :slug => 'the-ruby-way') to '/book/the-ruby-way'" do
    url(:book, :slug => 'the-ruby-way').should == '/book/the-ruby-way'
  end

  it "should route GET '/book/the-ruby-way' to Books#show with {:slug => 'the-ruby-way'}" do
    request_to('/book/the-ruby-way').should route_to(Books, :show).with(:slug => 'the-ruby-way')
  end
end

describe "The Boosk#isbn_lookup anonymous route" do
  it "should route GET '/book/1234567890' (a 10 digit ISBN) to Books#isbn_lookup with {:isbn => '1234567890'}" do
    request_to('/book/1234567890').should route_to(Books, :isbn_lookup).with(:isbn => '1234567890')
  end

  it "should route GET '/book/1234567891011' (a 13 digit ISBN) to Books#isbn_lookup with {:isbn => '1234567891011'}" do
    request_to('/book/1234567891011').should route_to(Books, :isbn_lookup).with(:isbn => '1234567891011')
  end

  it "should not route GET '/book/12345678910' (a 11 digit ISBN) to Books#isbn_lookup" do
    request_to('/book/12345678910').should_not route_to(Books, :isbn_lookup)
  end
end