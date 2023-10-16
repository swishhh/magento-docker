<?php

declare(strict_types=1);

namespace Console\Command;

use Console\Utils\GetCommands;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Helper\Table;

class Help extends Command
{
    protected function configure()
    {
        $this->setName('help');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $output->clear();
        $getCommands = new GetCommands();
        foreach ($getCommands->get() as $name => $command) {
            if ($command['class'] instanceof self) {
                continue;
            }
            $rows[] = ['<info>' . $name . '</info>', $command['description']];
        }

        $table = new Table($output);
        $table->setStyle('box');
        $table->setHeaders(['<comment>Command</comment>', '<comment>Description</comment>']);
        $table->setRows($rows ?? []);
        $table->render();

        return Command::SUCCESS;
    }
}