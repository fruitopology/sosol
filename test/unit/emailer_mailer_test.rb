require 'test_helper'

class EmailerMailerTest < ActionMailer::TestCase

  setup do
    @creator = FactoryGirl.create(:user, :name => "Creator", :email => "johndoe@email.com", :full_name => "John Doe")
    @publication = FactoryGirl.create(:publication, :owner => @creator, :creator => @creator, :status => "new", :title => "Publication Title")
    # branch from master so we aren't just creating an empty branch
    @publication.branch_from_master
    @ddb_identifier = DDBIdentifier.new_from_template(@publication)
    @ddb_identifier.title = "DDB Identifier Title"
    @ddb_identifier.save
    @test_comment = Comment.new(:comment => "A commment on an identifier", :identifier_id => @ddb_identifier.id, :publication_id => @publication.id, :reason => "General", :user => @creator)
    @test_comment.save
    @ddb_identifier.reload
    @publication.reload
    @board_publication = FactoryGirl.create(:publication, :owner => @creator, :creator => @creator, :status => "new", :title => "Board Publication Title")
    @publication.branch_from_master
    # branch from master so we aren't just creating an empty branch
  end

  teardown do 
    @publication.destroy
    @board_publication.destroy
    @creator.destroy
  end

  test "identifier_email with simple message no parsing no comments" do
    email = EmailerMailer.identifier_email("submitted",[@ddb_identifier],@board_publication,["johndoe@example.com"],false,false,"Plain message no parsing",nil).deliver
    assert ! ActionMailer::Base.deliveries.empty?
    assert_equal ['johndoe@example.com'], email.to
    assert_equal 'submitted: ' + @publication.title + " " + @ddb_identifier.title, email.subject
    assert_equal read_fixture('identifier_email').join, email.body.to_s
    assert true
  end

  test "identifier_email with simple message no parsing with comments" do
    email = EmailerMailer.identifier_email("submitted",[@ddb_identifier],@board_publication,["johndoe@example.com"],false,true,"Plain message no parsing","").deliver
    assert ! ActionMailer::Base.deliveries.empty?
    assert_equal ['johndoe@example.com'], email.to
    assert_equal 'submitted: ' + @publication.title + " " + @ddb_identifier.title, email.subject
    assert_equal read_fixture('identifier_email_comments').join.sub(/CREATED_AT/,@test_comment.created_at.to_formatted_s(:db)), email.body.to_s
    assert true
  end

  test "identifier_email with full parsing no comments" do
    email = EmailerMailer.identifier_email("submitted",[@ddb_identifier],@board_publication,["johndoe@example.com"],false,false,"!IDENTIFIER_TITLES !IDENTIFIER_LINKS !PUBLICATION_TITLE !PUBLICATION_LINK !PUBLICATION_CREATOR_NAME !BOARD_PUBLICATION_LINK",nil).deliver
    assert ! ActionMailer::Base.deliveries.empty?
    assert_equal ['johndoe@example.com'], email.to
    assert_equal 'submitted: ' + @publication.title + " " + @ddb_identifier.title, email.subject
    assert_equal read_fixture('identifier_parsing').join.gsub(/!PUBLICATION_ID/,@publication.id.to_s).gsub(/!IDENTIFIER_ID/,@ddb_identifier.id.to_s).gsub(/!BOARD_PUBLICATION_ID/,@board_publication.id.to_s), email.body.to_s
    assert true
  end

  test "identifier_email with simple message custom subject no parsing no comments" do
    email = EmailerMailer.identifier_email("submitted",[@ddb_identifier],@board_publication,["johndoe@example.com"],false,false,"Plain message no parsing","Custom Subject").deliver
    assert ! ActionMailer::Base.deliveries.empty?
    assert_equal ['johndoe@example.com'], email.to
    assert_equal "Custom Subject", email.subject
    assert_equal read_fixture('identifier_email').join, email.body.to_s
    assert true
  end

  test "identifier_email with simple message custom parsed subject no parsing no comments" do
    email = EmailerMailer.identifier_email("submitted",[@ddb_identifier],@board_publication,["johndoe@example.com"],false,false,"Plain message no parsing","Custom !TOPIC !IDENTIFIER_TITLES !PUBLICATION_TITLE").deliver
    assert ! ActionMailer::Base.deliveries.empty?
    assert_equal ['johndoe@example.com'], email.to
    assert_equal "Custom submitted " + @ddb_identifier.title + " " + @publication.title, email.subject
    assert_equal read_fixture('identifier_email').join, email.body.to_s
    assert true
  end

end
