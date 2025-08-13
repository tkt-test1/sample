# file_processor.rb

class FileProcessor
  # ファイルを読み込み、処理して、書き出すクラス

  # 特定のキーワードを含む行を抽出する
  def self.filter_lines_by_keyword(filename, keyword)
    # ファイルが存在しない場合はnilを返す
    return nil unless File.exist?(filename)

    lines = []
    # ファイルを1行ずつ読み込み、指定されたキーワードを含む行を配列に追加
    File.foreach(filename) do |line|
      lines << line if line.include?(keyword)
    end
    lines
  end

  # テキストの各行から余分なスペースを削除する
  def self.trim_lines(lines)
    lines.map(&:strip)
  end

  # 処理されたデータを新しいファイルに書き出す
  def self.write_to_file(filename, data)
    # 'w'モードでファイルを開き、既存の内容を上書きする
    File.open(filename, 'w') do |file|
      data.each do |line|
        file.puts line
      end
    end
    puts "処理されたデータを #{filename} に書き出しました。"
  end
end

# --- 実行例 ---

# シミュレーション用の入力データ
input_data = [
  "これはテスト用のデータです。",
  "重要な情報が含まれています。",
  "  空白が含まれる行です。 ",
  "これも重要な情報です。",
  "関連性のない行です。"
]

# 入力ファイルを作成（シミュレーション）
File.open("input_data.txt", 'w') do |file|
  input_data.each { |line| file.puts line }
end
puts "入力ファイル 'input_data.txt' を作成しました。"
puts "---"

# ファイルプロセッサーの利用
keyword = "重要"
filtered_lines = FileProcessor.filter_lines_by_keyword("input_data.txt", keyword)

if filtered_lines
  # 抽出された行から空白を削除
  trimmed_lines = FileProcessor.trim_lines(filtered_lines)

  # 処理後のデータを新しいファイルに書き出す
  output_filename = "processed_data.txt"
  FileProcessor.write_to_file(output_filename, trimmed_lines)
else
  puts "入力ファイルが見つかりません。"
end

# 実行後に作成されたファイルを削除するクリーンアップ処理（任意）
File.delete("input_data.txt") if File.exist?("input_data.txt")
File.delete("processed_data.txt") if File.exist?("processed_data.txt")
