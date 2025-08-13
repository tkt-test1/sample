<?php
// ShoppingCart.php

class ShoppingCart
{
    private array $items = [];
    private DiscountStrategy $discountStrategy;

    public function __construct(DiscountStrategy $strategy)
    {
        // 依存性の注入（DI）
        $this->discountStrategy = $strategy;
    }

    public function addItem(string $item, float $price): void
    {
        $this->items[$item] = $price;
    }

    public function calculateTotalPrice(): float
    {
        return array_sum($this->items);
    }

    public function getFinalPrice(): float
    {
        $totalPrice = $this->calculateTotalPrice();
        // 注入された戦略を使って割引を適用
        return $this->discountStrategy->apply($totalPrice);
    }
}

// --- 実行例 ---

// 複数のファイルを読み込む
require_once 'DiscountStrategy.php';
require_once 'FixedRateDiscount.php';
require_once 'ThresholdDiscount.php';

// 1. 10%割引戦略を適用
$fixedRateStrategy = new FixedRateDiscount(0.10);
$cart1 = new ShoppingCart($fixedRateStrategy);
$cart1->addItem('Laptop', 1000.00);
$cart1->addItem('Mouse', 50.00);

echo "合計金額（10%割引適用前）: " . $cart1->calculateTotalPrice() . "円\n";
echo "合計金額（10%割引適用後）: " . $cart1->getFinalPrice() . "円\n";
echo "--------------------\n";

// 2. 500円以上で100円引き戦略を適用
$thresholdStrategy = new ThresholdDiscount(500.00, 100.00);
$cart2 = new ShoppingCart($thresholdStrategy);
$cart2->addItem('Keyboard', 150.00);
$cart2->addItem('Monitor', 400.00);

echo "合計金額（500円以上で100円引き適用前）: " . $cart2->calculateTotalPrice() . "円\n";
echo "合計金額（500円以上で100円引き適用後）: " . $cart2->getFinalPrice() . "円\n";
