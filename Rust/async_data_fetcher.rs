use std::fmt::{self, Display};
use std::time::Duration;
use tokio::time::sleep;
use tokio::task;
use rand::Rng;

// --- 1. エラーを定義するカスタム型 ---
// Errorを実装することで、他のエラー型と互換性を持たせる
#[derive(Debug)]
pub enum FetchError {
    NetworkError(String),
    ServerError(u16),
}

impl Display for FetchError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            FetchError::NetworkError(msg) => write!(f, "Network Error: {}", msg),
            FetchError::ServerError(code) => write!(f, "Server Error: Status Code {}", code),
        }
    }
}

// 標準ライブラリのErrorトレイトを実装
impl std::error::Error for FetchError {}

// --- 2. ジェネリクスと非同期関数 ---
// トレイト制約を持つジェネリックな非同期関数
async fn mock_fetch<T>(endpoint: &str, data: T, min_delay_ms: u64, max_delay_ms: u64) -> Result<T, FetchError>
where
    T: Display + Clone,
{
    // ランダムな遅延をシミュレート
    let delay = rand::thread_rng().gen_range(min_delay_ms..=max_delay_ms);
    println!("[START] データ取得中: {} ({}ms)", endpoint, delay);
    sleep(Duration::from_millis(delay)).await;

    // 確率でエラーをシミュレート
    let error_chance = rand::thread_rng().gen_range(0..10);
    if error_chance < 2 {
        if error_chance == 0 {
            return Err(FetchError::NetworkError("Connection failed".to_string()));
        } else {
            return Err(FetchError::ServerError(500));
        }
    }

    println!("[DONE] データ取得完了: {}", endpoint);
    Ok(data)
}

// --- 3. メインの非同期処理 ---
#[tokio::main]
async fn main() {
    let endpoints = vec![
        "api/users",
        "api/products",
        "api/orders",
    ];

    println!("=== 全データ取得を開始 ===");

    // 複数の非同期タスクを並行して実行
    let mut tasks = Vec::new();
    for endpoint in endpoints {
        // tokio::spawnで新しい非同期タスクを作成
        let data = format!("Data from {}", endpoint);
        tasks.push(task::spawn(async move {
            mock_fetch(endpoint, data, 500, 1500).await
        }));
    }

    let mut success_count = 0;
    let mut error_count = 0;

    // 全てのタスクが完了するのを待機し、結果を処理
    for task in tasks {
        match task.await {
            Ok(result) => {
                match result {
                    Ok(data) => {
                        println!("✅ 成功: {}", data);
                        success_count += 1;
                    }
                    Err(e) => {
                        println!("❌ 失敗: {}", e);
                        error_count += 1;
                    }
                }
            }
            Err(e) => {
                // タスク自体がパニックした場合のエラー
                println!("❌ タスク実行中にエラーが発生: {}", e);
            }
        }
    }

    println!("=== 処理を終了 ===");
    println!("成功: {}, 失敗: {}", success_count, error_count);
}
