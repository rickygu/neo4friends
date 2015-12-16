require 'rails_helper'

RSpec.describe User, type: :model do
  it "can create user with number" do
    user = User.create number: 1
    expect(user.number).to eq 1
  end
  
  it "cannot create user with same number" do
    user = User.create number: 1
    expect{User.create(number: 1)}.to raise_error(Neo4j::Server::CypherResponse::ConstraintViolationError)
  end
  
  it "cannot create user with invalid id" do
    expect{user = User.create! number: "abc"}.to raise_error(Neo4j::ActiveNode::Persistence::RecordInvalidError)
  end
  
  it "can silently ignore creating user with invalid number" do
    User.create number: "abc"
    expect(User.count).to eq 0
  end
   
  it "can add another user as friend" do
    user = User.create number: 1
    user2 = User.create number: 2
    user.make_friends(user2)
    expect(user.friends.first).to eq user2
    expect(user2.friends.first).to eq user
    expect(user.friends.count).to eq 1
    expect(user2.friends.count).to eq 1
  end
  
  it "cannot add another user as friend twice silently" do
    user = User.create number: 1
    user2 = User.create number: 2
    user.make_friends user2
    expect(user.friends.count).to eq 1
    expect(user2.friends.count).to eq 1
    user.make_friends user2
    expect(user.friends.count).to eq 1
    expect(user2.friends.count).to eq 1
  end
  
  it "can throw exception if friendship already exist" do
    user = User.create number: 1
    user2 = User.create number: 2
    user.make_friends! user2
    expect{user.make_friends! user2}.to raise_error("Friendship already exist")
  end
  
  it "cannot add another user back as friend once friended" do
    user = User.create number: 1
    user2 = User.create number: 2
    user.make_friends user2
    expect(user.friends.count).to eq 1
    expect(user2.friends.count).to eq 1
    user2.make_friends user
    expect(user.friends.count).to eq 1
    expect(user2.friends.count).to eq 1
  end
  
  it "can import from CSV file" do
    User.import
    
  end
  
end
