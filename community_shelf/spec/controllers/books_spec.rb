require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Books, "index action" do
  before(:each) do
    dispatch_to(Books, :index)
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