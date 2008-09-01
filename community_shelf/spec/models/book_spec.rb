require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Book do

  before(:each) do
    DataMapper.auto_migrate!
  end

  describe "#title" do
    it "should not be blank unless both the short & long titles are blank" do
      book = Book.new(:short_title => "short", :long_title => "long")
      book.title.should_not be_blank

      book.short_title = book.long_title = ""
      book.title.should be_blank
    end

    it "should return the short title unless it's blank" do
      book = Book.new(:short_title => "short", :long_title => "long")
      book.title.should == book.short_title

      book.short_title = ""
      book.title.should_not == book.short_title
    end

    it "should return the long title only if the short title is blank" do
      book = Book.new(:long_title => "long")
      book.title.should == book.long_title

      book.short_title = "short"
      book.title.should_not == book.long_title
    end
  end

  describe "Validations" do
    it "should ensure the short_title or long_title is present through the title presence validation" do
      book = Book.new(:short_title => nil, :long_title => nil)

      book.should_not be_valid
      book.errors[:title].should_not be_nil
      book.errors[:title].should_not be_empty
    end
  end
end