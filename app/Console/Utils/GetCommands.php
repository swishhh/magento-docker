<?php

declare(strict_types=1);

namespace Console\Utils;

use Exception;
use Symfony\Component\Console\Command\Command;
use Throwable;

class GetCommands
{
    private const XML_FILE = ROOT . '/app/etc/command.xml';

    public function get(): array
    {
        try {
            $xml = simplexml_load_file(self::XML_FILE);
            if ($xml) {
                foreach ($xml as $node) {
                    $name = $node->attributes()->name->__toString();
                    $class = new ($node->class->__toString());
                    $description = $node->description->__toString();

                    if (!$class instanceof Command) {
                        throw new Exception($class . ' should implement ' . Command::class);
                    }

                    $commands[$name] = [
                        'class' => $class,
                        'description' => $description
                    ];
                }
            }
        } catch (Throwable $e) {
            return [];
        }

        return $commands ?? [];
    }
}