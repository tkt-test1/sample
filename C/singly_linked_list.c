#include <stdio.h>
#include <stdlib.h>

// リンクリストのノードを定義する構造体
typedef struct Node {
    int data;            // ノードが保持するデータ
    struct Node* next;   // 次のノードへのポインタ
} Node;

// リンクリストの先頭ノードへのポインタ
Node* head = NULL;

// --- 1. ノードをリストの先頭に追加する関数 ---
void add_node(int value) {
    // 新しいノードのメモリを動的に割り当てる
    Node* new_node = (Node*)malloc(sizeof(Node));
    if (new_node == NULL) {
        printf("メモリ割り当てに失敗しました。\n");
        exit(1);
    }
    
    // 新しいノードにデータを設定
    new_node->data = value;
    
    // 新しいノードのnextポインタを現在のheadに設定
    new_node->next = head;
    
    // リストの先頭を新しいノードに更新
    head = new_node;
    printf("ノード %d を追加しました。\n", value);
}

// --- 2. リストの要素を全て表示する関数 ---
void print_list() {
    Node* current = head;
    if (current == NULL) {
        printf("リストは空です。\n");
        return;
    }
    
    printf("リストの要素: ");
    while (current != NULL) {
        printf("%d -> ", current->data);
        current = current->next; // ポインタを次のノードに進める
    }
    printf("NULL\n");
}

// --- 3. リスト全体のメモリを解放する関数 ---
void free_list() {
    Node* current = head;
    Node* next_node;
    
    printf("リストのメモリを解放中...\n");
    while (current != NULL) {
        next_node = current->next; // 次のノードへのポインタを一時的に保存
        free(current);             // 現在のノードのメモリを解放
        current = next_node;       // 次のノードに進める
    }
    head = NULL; // リストの先頭ポインタをNULLにリセット
    printf("メモリ解放が完了しました。\n");
}

// メイン関数
int main() {
    printf("--- 単方向リンクリストの操作 --- \n");
    
    // リストにノードを追加
    add_node(10);
    add_node(20);
    add_node(30);
    
    // リストの内容を表示
    print_list();
    
    // リストのメモリを解放
    free_list();
    
    // 解放後のリストを表示（空になっていることを確認）
    print_list();
    
    return 0;
}
