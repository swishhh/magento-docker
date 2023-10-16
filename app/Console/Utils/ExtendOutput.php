<?php

declare(strict_types=1);

namespace Console\Utils;

use Symfony\Component\Console\Formatter\OutputFormatterStyle;
use Symfony\Component\Console\Output\OutputInterface;

class ExtendOutput
{
    private const STYLES = [
        'success' => ['green', '', []],
        'success-bold' => ['green', '', ['bold']],
        'intro' => ['cyan', '', ['bold']]
    ];

    public function extend(OutputInterface $output): void
    {
        foreach (self::STYLES as $name => $config) {
            $output->getFormatter()->setStyle($name, new OutputFormatterStyle(...$config));
        }
    }
}