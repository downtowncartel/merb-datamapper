# community_shelf/spec/controllers/books.rb

require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Books, "index action" do
  before(:each) do
    DataMapper.auto_migrate!
    5.times {User.gen}
  end

  it "should query by the catalog term, paginate, then display the results successfully" do
    term = ('a'..'z').pick
    matching_catalog = 50.of {Book.gen(:short_title => /#{term}[:sentence:]{3,5}/.gen)}

    dispatch_to(Books, :index, :term => term) { |controller|
      controller.should_receive(:display)
    }.should be_successful
  end

  it "should raise a NotFound if the catalog is empty" do
    term = ('a'..'z').pick
    Book.by_catalog(term).should be_empty

    lambda {
      dispatch_to(Books, :index, :term => term)
    }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
end

describe Books, "show action" do
  it "should find the first book that matches the slug, and display the book" do
    book = mock(:book)
    Book.should_receive(:first).with(:slug => "pragprog").and_return book

    dispatch_to(Books, :show, :slug => "pragprog") do |controller|
      controller.should_receive(:display).with(book)
    end
  end

  it "should raise a NotFound exception if the slug parameter does not match a book" do
    Book.should_receive(:first).and_return nil

    lambda {
      dispatch_to(Books, :show, :slug => "pragprog")

    }.should raise_error(Merb::ControllerExceptions::NotFound, :book_slug => "pragprog")
  end
end