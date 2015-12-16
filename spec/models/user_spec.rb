require 'rails_helper'

RSpec.describe User, type: :model do
  it "can create user with number" do
    user = User.create number: 1
    expect(user.number).to eq 1
  end
end
