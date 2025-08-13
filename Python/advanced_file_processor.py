import time
import functools
from contextlib import contextmanager

# --- 1. デコレータ ---
# 実行時間を計測し、ログを出力するデコレータ
def log_execution_time(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        end_time = time.time()
        execution_time = end_time - start_time
        print(f"'{func.__name__}' の実行時間: {execution_time:.4f} 秒")
        return result
    return wrapper

# --- 2. コンテキストマネージャ ---
# ファイルリソースを安全に管理するコンテキストマネージャ
@contextmanager
def managed_file(filename, mode):
    """
    with文を使ってファイルを自動で開閉する
    """
    print(f"ファイル '{filename}' を開きます。")
    file = open(filename, mode, encoding='utf-8')
    try:
        yield file
    finally:
        print(f"ファイル '{filename}' を閉じます。")
        file.close()

# --- 3. ジェネレータ ---
# 大量のデータをメモリ効率良く処理するジェネレータ
def read_large_file_generator(filename):
    """
    ファイルから1行ずつデータを生成するジェネレータ
    """
    with managed_file(filename, 'r') as file:
        for line in file:
            yield line.strip()

# --- 4. 実行クラス ---
class FileDataProcessor:

    @log_execution_time
    def process(self, input_filename, output_filename, keyword):
        """
        ファイルからキーワードを含む行を抽出し、別のファイルに書き出す
        """
        # ジェネレータを使ってメモリを節約しながらデータを処理
        filtered_lines = [line for line in read_large_file_generator(input_filename) if keyword in line]

        # コンテキストマネージャを使って出力ファイルに書き込み
        with managed_file(output_filename, 'w') as output_file:
            for line in filtered_lines:
                output_file.write(line + "\n")
        
        print(f"キーワード '{keyword}' を含む {len(filtered_lines)} 行を '{output_filename}' に書き込みました。")
        return len(filtered_lines)

# --- 実行例 ---
if __name__ == "__main__":
    # シミュレーション用の大きな入力データを作成
    input_filename = "large_input.txt"
    with open(input_filename, 'w', encoding='utf-8') as f:
        for i in range(100000):
            if i % 1000 == 0:
                f.write(f"This is a line with a special keyword. ID: {i}\n")
            else:
                f.write(f"This is a normal line. ID: {i}\n")
    
    print("シミュレーション用の入力ファイルを作成しました。")
    print("---")
    
    processor = FileDataProcessor()
    
    # 処理を実行
    processor.process(input_filename, "output.txt", "keyword")
    
    # クリーンアップ
    import os
    os.remove(input_filename)
    os.remove("output.txt")
