<?php

declare(strict_types=1);

namespace Console\Utils;

use Symfony\Component\Console\Output\ConsoleOutput;
use Symfony\Component\Console\Output\Output as BaseOutput;

class Output extends ConsoleOutput
{
    public function writeln(
        $messages,
        $options = BaseOutput::OUTPUT_NORMAL,
        bool $clear = false,
        bool $nlStart = false,
        bool $nlEnd = false,
        bool $nlWrap = false
    ) {
        if ($clear) {
            $this->clear();
        }

        if ($nlStart || $nlWrap) {
            $this->write(PHP_EOL);
        }

        parent::writeln($messages, $options);

        if ($nlEnd || $nlWrap) {
            $this->write(PHP_EOL);
        }
    }

    public function writeHeader($helpInfo = false): void
    {
        $this->writeln(
            "<intro>
  __  __ ___   ___         _           
 |  \/  |_  ) |   \ ___ __| |_____ _ _ 
 | |\/| |/ /  | |) / _ / _| / / -_| '_|
 |_|  |_/___| |___/\___\__|_\_\___|_|
                    </intro>",
            clear: true
        );
        $helpInfo && $this->writeHelpInfo();
    }

    public function writeHelpInfo(): void
    {
        $this->writeln('Current script executor: <info>' . get_current_user() . '</info>');
        $this->writeln('System: <comment>' . php_uname() . '</comment>', nlEnd: true);
        $this->writeln('<comment>-h --help</comment> - Get list of available commands.');
    }

    public function clear(): void
    {
        $this->write("\033\143");
        $this->section()->clear();
    }
}