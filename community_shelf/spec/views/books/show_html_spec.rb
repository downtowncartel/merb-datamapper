require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "books/show.html" do
  before(:each) do
    DataMapper.auto_migrate!
    @book = Book.gen(:owner => User.gen)

    @response = dispatch_to(Books, :show, :slug => @book.slug)
  end

  it "should display the title inside an h2" do
    @response.body.should have_tag(:h2) {|h2| h2.should contain(@book.title)}
  end

  it "should display the author inside an author h3" do
    @response.body.should have_tag(:h3, :class => :author) {|h3| h3.should contain(@book.author)}
  end

  it "should display the ISBN within an h4 inside a div of span 6" do
    @response.body.should have_selector("div.span-6 h4") {|h4| h4.should contain(@book.isbn)}
  end
end