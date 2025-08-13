<?php
// FixedRateDiscount.php

class FixedRateDiscount implements DiscountStrategy
{
    private float $rate;

    public function __construct(float $rate)
    {
        $this->rate = $rate;
    }

    public function apply(float $originalPrice): float
    {
        return $originalPrice * (1 - $this->rate);
    }
}
