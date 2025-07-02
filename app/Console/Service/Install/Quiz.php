<?php

declare(strict_types=1);

namespace Console\Service\Install;

use Console\Service\Install\Quiz\Data;
use Symfony\Component\Console\Helper\QuestionHelper;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Question\Question;
use Console\Service\Install\Validate\Domain as DomainValidator;

class Quiz
{
    public function __construct(
        private readonly QuestionHelper $helper,
        private readonly InputInterface $input,
        private readonly OutputInterface $output
    ) {
    }

    public function execute(): Data
    {
        $name = $this->getName();
        $domain = $this->getDomain($name);

        return new Data(
            $name,
            $domain,
            $this->getMagentoPath(),
            $this->getPHP(),
            $this->getMysql(),
            $this->getVarnish(),
            $this->getSearchEngine(),
            $this->getRabbitMQ(),
            $this->getRedis()
        );
    }

    private function getName(): string
    {
        $name = '';
        while (!$name) {
            $name = strtolower($this->ask('<fg=blue>Name</>: '));
            if (!$name) {
                $this->output->writeln('<error>Please enter a valid name!</error>');
            } else {
                $this->output->writeln('Name of the project: <comment>' . $name . '</comment>');
            }
        }

        $this->output->writeln('');

        return $name;
    }

    public function getDomain(string $name): string
    {
        $default = $name . '.lc';
        $this->output->writeln('<fg=blue>Domain</> (magento.lc etc.)');
        $proceedWithDefault = $this->ask('Proceed with <info>' . $default . '</info>? <comment>[Y/n]</comment>');
        if (in_array($proceedWithDefault, ['Y', 'y'])) {
            $domain = $default;
        } else {
            $domain = '';
            while ($domain === '') {
                $domain = $this->ask('Enter valid domain: ');
                if (!DomainValidator::validate($domain)) {
                    $this->output->writeln('<error>Provided domain is invalid! Please try another one.</error>');
                    $domain = '';
                }
            }
        }

        return $domain;
    }

    public function getMagentoPath(): string
    {
        return '';
    }

    public function getPHP(): int
    {
        return 1;
    }

    public function getMysql(): int
    {
        return 1;
    }

    public function getVarnish(): int
    {
        return 0;
    }

    public function getSearchEngine(): int
    {
        return 0;
    }

    public function getRabbitMQ(): int
    {
        return 0;
    }

    public function getRedis(): int
    {
        return 0;
    }

    /**
     * Ask a question.
     *
     * @param string $message
     *
     * @return string
     */
    private function ask(
        string $message
    ): string {
        $question = new Question($message, false);

        return (string) $this->helper->ask($this->input, $this->output, $question);
    }
}