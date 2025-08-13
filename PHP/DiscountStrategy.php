<?php
// DiscountStrategy.php

interface DiscountStrategy
{
    /**
     * 割引を適用した後の価格を計算する
     * @param float $originalPrice 元の価格
     * @return float 割引適用後の価格
     */
    public function apply(float $originalPrice): float;
}
