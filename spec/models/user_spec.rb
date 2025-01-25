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

  it "メールアドレスが入力されているか" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("メールアドレスを入力してください")
  end

  it "メールアドレスがユニークか" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "test@example.com")
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("メールアドレスはすでに存在します")
  end

  it "メールアドレスが有効な形式か" do
    user = build(:user, email: "test")
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("有効なメールアドレスを入力してください")
  end
end
