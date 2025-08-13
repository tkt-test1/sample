// type_safe_data_processor.ts

/**
 * データの変換ロジックを定義する関数型
 * Tは変換前のデータ型、Uは変換後のデータ型
 */
type Transformer<T, U> = (data: T) => U;

/**
 * Mapped Typesを使って、オブジェクトの全てのプロパティをオプショナルにする型
 */
type Partial<T> = {
  [P in keyof T]?: T[P];
};

/**
 * 複数の異なる変換関数を扱うための型
 * Record<string, Transformer<any, any>> は、キーが文字列、値がTransformerであるオブジェクトを意味する
 */
type TransformationMap = Record<string, Transformer<any, any>>;

// --- 1. ジェネリクスを使ったユーティリティクラス ---

/**
 * 汎用的なデータ変換処理を行うクラス
 * <T extends object> は、Tがオブジェクトであることを示すジェネリクス制約
 */
class DataProcessor<T extends object> {
  private data: T[];

  constructor(data: T[]) {
    this.data = data;
  }

  /**
   * 指定した変換ロジックをデータに適用する
   * @param transformer - 変換ロジックを定義した関数
   * @returns {U[]} - 変換後のデータの配列
   */
  public transform<U>(transformer: Transformer<T, U>): U[] {
    return this.data.map(transformer);
  }

  /**
   * 複数の変換ロジックを、プロパティ名を指定して適用する
   * Union TypeとGenericsを組み合わせた高度な例
   * @param transformMap - プロパティ名と変換関数のマッピング
   * @returns {Partial<T>[]} - 変換されたプロパティのみを持つデータの配列
   */
  public partialTransform(transformMap: TransformationMap): Partial<T>[] {
    return this.data.map(item => {
      const newItem: Partial<T> = {};
      for (const key in transformMap) {
        if (transformMap.hasOwnProperty(key)) {
          // 型安全のためにキーの存在をチェック
          const value = (item as any)[key];
          if (value !== undefined) {
            (newItem as any)[key] = transformMap[key](value);
          }
        }
      }
      return newItem;
    });
  }
}

// --- 実行例 ---

// 変換前のデータ型を定義
interface User {
  id: number;
  username: string;
  email: string;
  createdAt: Date;
}

// データ配列
const users: User[] = [
  { id: 1, username: "alice_chan", email: "alice@example.com", createdAt: new Date() },
  { id: 2, username: "bob_kun", email: "bob@example.com", createdAt: new Date() }
];

// DataProcessorインスタンスを作成
const processor = new DataProcessor<User>(users);

// --- パターン1: データを別の型に完全に変換 ---

// 変換後のデータ型を定義
interface UserSummary {
  id: number;
  username: string;
}

const userSummaries = processor.transform<UserSummary>(user => ({
  id: user.id,
  username: user.username.toUpperCase() // 名前を大文字に変換
}));

console.log("パターン1: データを別の型に変換");
console.log(userSummaries);
console.log("---");

// --- パターン2: 特定のプロパティのみを変換 ---

// 部分的な変換ロジックを定義
const partialTransformers = {
  username: (name: string) => `(NEW) ${name}`,
  email: (email: string) => email.toLowerCase(),
  createdAt: (date: Date) => date.toISOString()
};

const partiallyTransformedUsers = processor.partialTransform(partialTransformers);

console.log("パターン2: 特定のプロパティのみを変換");
console.log(partiallyTransformedUsers);
