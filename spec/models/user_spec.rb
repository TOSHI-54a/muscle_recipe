require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a name, email, and age" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include("名前を入力してください")
  end

  it "is invalid with a duplicate email" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "test@example.com")
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("メールアドレスはすでに存在します")
  end

end
