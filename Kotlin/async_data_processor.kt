import kotlinx.coroutines.*
import kotlin.random.Random

// --- 1. 拡張関数 ---
// Intの拡張関数として、指定したミリ秒数スリープする関数を定義
// suspendキーワードは、この関数がコルーチン内で呼び出されることを示す
suspend fun Int.delayMillis() = delay(this.toLong())

// --- 2. 高階関数 ---
// データ取得と変換を抽象化する高階関数
// Tは元の型、Uは変換後の型
suspend fun <T, U> fetchDataAndTransform(
    fetcher: suspend () -> T, // データを取得するsuspend関数
    transformer: (T) -> U // データを変換する関数
): U {
    val data = fetcher()
    return transformer(data)
}

// --- 3. 非同期処理とクラス ---
class DataFetcher {
    // ユーザーデータを非同期で取得するsuspend関数
    suspend fun fetchUserData(): String {
        println("[START] ユーザーデータ取得中...")
        // 処理の遅延をシミュレート
        Random.nextInt(500, 1500).delayMillis()
        println("[DONE] ユーザーデータ取得完了")
        return "Alice, Bob, Charlie"
    }

    // 商品データを非同期で取得するsuspend関数
    suspend fun fetchProductData(): String {
        println("[START] 商品データ取得中...")
        Random.nextInt(500, 1500).delayMillis()
        println("[DONE] 商品データ取得完了")
        return "Laptop, Mouse, Keyboard"
    }
}

// メイン関数
fun main() = runBlocking {
    println("=== 非同期データ取得を開始 ===")
    val dataFetcher = DataFetcher()

    // asyncを使って複数の非同期タスクを並行で実行
    val userDeferred = async { dataFetcher.fetchUserData() }
    val productDeferred = async { dataFetcher.fetchProductData() }

    // awaitで結果を待機し、取得
    val userData = userDeferred.await()
    val productData = productDeferred.await()

    println("=== 全データの取得が完了 ===")

    // 高階関数とラムダ式を使ってデータを処理
    val transformedUsers = fetchDataAndTransform(
        fetcher = { userData },
        transformer = { it.split(", ").map { name -> name.trim().toUpperCase() } }
    )

    val transformedProducts = fetchDataAndTransform(
        fetcher = { productData },
        transformer = { it.split(", ").map { product -> product.trim().toLowerCase() } }
    )

    println("処理済みユーザー: $transformedUsers")
    println("処理済み商品: $transformedProducts")

    println("=== 処理を終了 ===")
}
