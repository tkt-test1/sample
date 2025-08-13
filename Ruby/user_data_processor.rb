# user_data_processor.rb

class UserDataProcessor
  # ユーザーのデータを処理するクラス

  # 有効なユーザー名かチェックする
  def self.valid_username?(username)
    # ユーザー名がnilでないこと、空でないこと、そして特定の文字数制限内であることを確認
    return false if username.nil? || username.strip.empty?
    username.length.between?(3, 20)
  end

  # メールアドレスの形式を検証する
  def self.valid_email?(email)
    # 簡単な正規表現でメールアドレスの形式をチェック
    return false if email.nil?
    email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end

  # ユーザーデータが全て有効かまとめてチェックする
  def self.validate_user(user_data)
    # user_dataはハッシュ形式を想定: { username: "...", email: "..." }
    valid_username?(user_data[:username]) && valid_email?(user_data[:email])
  end

  # ユーザーデータを整形する
  def self.format_user_data(user_data)
    # ユーザー名を大文字に、メールアドレスを小文字に変換する例
    {
      username: user_data[:username].upcase,
      email: user_data[:email].downcase
    }
  end

  # データベースに保存する処理をシミュレート
  def self.save_to_database_mock(user_data)
    if validate_user(user_data)
      # 実際にDBに接続する代わりに、コンソールに出力
      puts "データベースに以下のユーザーデータを保存しました（シミュレーション）: #{format_user_data(user_data)}"
      true
    else
      puts "無効なデータのため、保存できませんでした。"
      false
    end
  end
end

# --- 実行例 ---

# 有効なユーザーデータ
valid_user = { username: "test_user_1", email: "Test.User@example.com" }
UserDataProcessor.save_to_database_mock(valid_user)

puts "---"

# 無効なユーザーデータ（ユーザー名が短すぎる）
invalid_user_1 = { username: "te", email: "user_2@example.com" }
UserDataProcessor.save_to_database_mock(invalid_user_1)

puts "---"

# 無効なユーザーデータ（メールアドレスの形式が不正）
invalid_user_2 = { username: "test_user_3", email: "invalid_email" }
UserDataProcessor.save_to_database_mock(invalid_user_2)
