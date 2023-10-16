<?php

declare(strict_types=1);

namespace Console\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Status extends Command
{
    protected function configure()
    {
        $this->setName('status');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $output->writeHeader(helpInfo: true);
        $output->writeln('<error>Needs implementation.</error>', nlStart: true);
        return Command::SUCCESS;
    }
}