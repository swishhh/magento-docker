<?php

declare(strict_types=1);

namespace Console\Command;

use Console\Utils\Output;
use Exception;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\StringInput;
use Symfony\Component\Console\Output\OutputInterface;
use Console\Utils\ExtendOutput;
use Console\Utils\GetCommands;
use Symfony\Component\Console\Helper\QuestionHelper;
use Symfony\Component\Console\Question\Question;
use Symfony\Component\Console\Exception\ExceptionInterface;

class Stream extends Command
{
    private static array $commands;

    protected function configure()
    {
        $this->setName('home')
            ->setDescription('Clear output of the cli.');
    }

    /**
     * @param InputInterface $input
     * @param OutputInterface $output
     * @return int
     * @throws ExceptionInterface|Exception
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $extendOutput = new ExtendOutput();
        $extendOutput->extend($output);

        $output->writeHeader(helpInfo: true);

        while (true) {
            $commandName = $this->ask($input, $output); // todo: parse command and arguments.
            if ($commandName === 'exit') {
                break;
            }

            $command = $this->getCommandByName($commandName);
            if (!$command) {
                $output->writeHeader();
                $output->writeln('<comment>-h --help</comment> - Get list of available commands.');
                $output->writeln('<error>There is no commands as "' . $commandName . '"</error>', nlStart: true);
            }

            $commandInput = new StringInput('');
            $commandOutput = new Output();
            $extendOutput->extend($commandOutput);
            $command?->run(
                $commandInput,
                $commandOutput
            );
        }

        return Command::SUCCESS;
    }

    /**
     * @param InputInterface $input
     * @param OutputInterface $output
     *
     * @return string
     */
    private function ask(
        InputInterface $input,
        OutputInterface $output
    ): string {
        /** @var QuestionHelper $helper */
        $helper = $this->getHelper('question');
        $question = new Question('', false);

        $output->writeln('');

        return str_replace('--', '', (string) $helper->ask($input, $output, $question));
    }

    /**
     * @param string $name
     * @return Command|null
     *
     * @throws Exception
     */
    private function getCommandByName(string $name): ?Command
    {
        $commands = $this->getCommands();

        return $commands[$name]['class'] ?? null;
    }

    /**
     * @return array[]
     * @throws Exception
     */
    private function getCommands(): array
    {
        if (isset(self::$commands)) {
           return self::$commands;
        }

        $getCommands = new GetCommands();

        return self::$commands = $getCommands->get();
    }
}