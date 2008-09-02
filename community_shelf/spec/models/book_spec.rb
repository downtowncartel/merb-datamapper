require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Book do

  describe ".by_catalog" do
    before(:each) do
      DataMapper.auto_migrate!
      5.times {User.gen}
    end

    it "should query only books with slug beginning with the search term" do
      term = ('a'..'y').pick
      matching_catalog = 50.of {Book.gen(:short_title => /#{term}[:sentence:]{3,5}/.gen)}
      external_catalog = 50.of {Book.gen(:short_title => /#{term.succ}[:sentence:]{3,5}/.gen)}

      Book.by_catalog(term).each do |book|
        matching_catalog.should include(book)
        external_catalog.should_not include(book)
      end
    end
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

    it "should ensure the isbn number is 13 digits" do
      book = Book.new(:isbn => "123456789")

      book.should_not be_valid
      book.errors[:validate_isbn].should_not be_nil
      book.errors[:validate_isbn].should_not be_empty

      book.errors[:validate_isbn].first.should == "'123456789' is in an invalid ISBN format"
    end

    it "should ensure the isbn number is valid" do
      book = Book.new(:isbn => "1234567891011")

      ISBN_Tools.should_receive(:is_valid?).with("1234567891011").and_return false

      book.should_not be_valid
      book.errors[:validate_isbn].should_not be_nil
      book.errors[:validate_isbn].first.should == "'1234567891011' is an invalid ISBN number"
    end

    it "should have no validation errors for :validate_isbn if ISBN_Tools determines the number to be valid" do
      book = Book.new(:isbn => "1234567891011")

      ISBN_Tools.should_receive(:is_valid?).with("1234567891011").and_return true

      book.valid?
      book.errors[:validate_isbn].should be_nil
    end
  end
end