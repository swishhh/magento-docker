<?php

declare(strict_types=1);

namespace Console\Utils;

class Registry
{
    private static array $registry;

    public static function set(string $key, mixed $value): void
    {
        if (!isset(self::$registry)) {
            self::$registry = [];
        }

        self::$registry[$key] = $value;
    }

    public static function get(string $key): mixed
    {
        return self::$registry[$key] ?? null;
    }
}