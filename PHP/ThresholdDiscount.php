<?php
// ThresholdDiscount.php

class ThresholdDiscount implements DiscountStrategy
{
    private float $threshold;
    private float $deduction;

    public function __construct(float $threshold, float $deduction)
    {
        $this->threshold = $threshold;
        $this->deduction = $deduction;
    }

    public function apply(float $originalPrice): float
    {
        if ($originalPrice >= $this->threshold) {
            return $originalPrice - $this->deduction;
        }
        return $originalPrice;
    }
}
