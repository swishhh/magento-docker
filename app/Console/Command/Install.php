<?php

declare(strict_types=1);

namespace Console\Command;

use Console\Utils\Registry;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Console\Service\Install\Quiz;

class Install extends Command
{
    protected function configure()
    {
        $this->setName('install');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $output->writeHeader(); // todo: replace with install header and description.
        $output->writeln('');
        $quiz = new Quiz($this->getHelper('question'), $input, $output);
        $data = $quiz->execute();


        return Command::SUCCESS;
    }
}