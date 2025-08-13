import Foundation

// --- 1. プロトコル（Protocol） ---
// CSVから初期化可能な、IDを持つ型であることを要求するプロトコル
protocol CsvInitializable: Identifiable {
    init?(csvData: [String])
}

// --- 2. 構造体（データモデル） ---
// プロトコルに準拠したデータモデルを定義
struct User: CsvInitializable, Codable {
    let id: Int
    let name: String
    let email: String
    
    // プロトコルの要求を満たすイニシャライザ
    init?(csvData: [String]) {
        guard csvData.count == 3, let id = Int(csvData[0]) else {
            return nil
        }
        self.id = id
        self.name = csvData[1]
        self.email = csvData[2]
    }
}

struct Product: CsvInitializable, Codable {
    let id: Int
    let name: String
    let price: Double
    
    init?(csvData: [String]) {
        guard csvData.count == 3, let id = Int(csvData[0]), let price = Double(csvData[2]) else {
            return nil
        }
        self.id = id
        self.name = csvData[1]
        self.price = price
    }
}

// --- 3. ジェネリクスと高階関数を使った処理クラス ---
enum DataProcessingError: Error {
    case fileNotFound
    case dataParsingError(line: Int, reason: String)
}

class CsvProcessor {
    
    // ジェネリックな関数で、任意のCsvInitializable型を処理する
    // `T` は `CsvInitializable` プロトコルに準拠していなければならない
    func processCsv<T: CsvInitializable>(filename: String) throws -> [T] {
        guard let path = Bundle.main.path(forResource: filename, ofType: "csv") else {
            throw DataProcessingError.fileNotFound
        }
        
        let contents = try String(contentsOfFile: path)
        let lines = contents.split(separator: "\n").map { String($0) }
        
        // 高階関数 `compactMap` を使って、各行をT型に変換する
        return lines.compactMap { line in
            let components = line.split(separator: ",").map { String($0) }
            return T(csvData: components)
        }
    }
    
    // データフィルタリング用の高階関数
    // `T` は `Identifiable` プロトコルに準拠していなければならない
    func filterData<T: Identifiable>(data: [T], predicate: (T) -> Bool) -> [T] {
        return data.filter(predicate)
    }
}

// --- 実行例 ---
// CSVファイルをシミュレートするための準備
// 実際にはアプリのプロジェクトにcsvファイルを追加する必要があります

// 以下の内容で users.csv を作成
// 1,Alice,alice@example.com
// 2,Bob,bob@example.com
// 3,Charlie,charlie@example.com

// 以下の内容で products.csv を作成
// 101,Laptop,1200.00
// 102,Mouse,50.00
// 103,Keyboard,150.00

let processor = CsvProcessor()

do {
    // User型のデータを処理
    let users: [User] = try processor.processCsv(filename: "users")
    print("--- ユーザーデータの読み込み ---")
    print(users)
    
    // 高階関数を使って特定のユーザーをフィルタリング
    let alice = processor.filterData(data: users) { $0.name == "Alice" }
    print("\n--- 'Alice'をフィルタリング ---")
    print(alice)
    
    // Product型のデータを処理
    let products: [Product] = try processor.processCsv(filename: "products")
    print("\n--- 商品データの読み込み ---")
    print(products)
    
    let expensiveProducts = processor.filterData(data: products) { $0.price > 100 }
    print("\n--- 価格が100ドル以上の商品をフィルタリング ---")
    print(expensiveProducts)
    
} catch DataProcessingError.fileNotFound {
    print("指定されたファイルが見つかりませんでした。")
} catch {
    print("その他のエラーが発生しました: \(error)")
}
