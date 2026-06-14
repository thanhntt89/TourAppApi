<?php
defined('ABSPATH') || exit;

class TA_Geo {

    public static function distance_km(float $lat1, float $lng1, float $lat2, float $lng2): float {
        $earth_radius = 6371;

        $lat1_rad = deg2rad($lat1);
        $lat2_rad = deg2rad($lat2);
        $dlat     = deg2rad($lat2 - $lat1);
        $dlng     = deg2rad($lng2 - $lng1);

        $a = sin($dlat / 2) * sin($dlat / 2)
           + cos($lat1_rad) * cos($lat2_rad) * sin($dlng / 2) * sin($dlng / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earth_radius * $c;
    }

    public static function distance_meters(float $lat1, float $lng1, float $lat2, float $lng2): float {
        return self::distance_km($lat1, $lng1, $lat2, $lng2) * 1000;
    }

    public static function is_within_radius(float $lat, float $lng, float $center_lat, float $center_lng, float $radius_meters): bool {
        return self::distance_meters($lat, $lng, $center_lat, $center_lng) <= $radius_meters;
    }

    public static function sort_by_distance(array $items, float $lat, float $lng, string $lat_key = 'latitude', string $lng_key = 'longitude'): array {
        usort($items, function ($a, $b) use ($lat, $lng, $lat_key, $lng_key) {
            $dist_a = self::distance_km($lat, $lng, $a[$lat_key], $a[$lng_key]);
            $dist_b = self::distance_km($lat, $lng, $b[$lat_key], $b[$lng_key]);
            return $dist_a <=> $dist_b;
        });
        return $items;
    }
}
