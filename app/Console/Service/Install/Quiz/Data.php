<?php

declare(strict_types=1);

namespace Console\Service\Install\Quiz;

class Data
{
    public function __construct(
        private readonly string $name,
        private readonly string $domain,
        private readonly string $magentoPath,
        private readonly int $php,
        private readonly int $mysql,
        private readonly int $varnish,
        private readonly int $searchEngine,
        private readonly int $rabbitmq,
        private readonly int $redis
    ) {
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getDomain(): string
    {
        return $this->domain;
    }

    public function getMagentoPath(): string
    {
        return $this->magentoPath;
    }

    public function getPHP(): int
    {
        return $this->php;
    }

    public function getMysql(): int
    {
        return $this->mysql;
    }

    public function getVarnish(): int
    {
        return $this->varnish;
    }

    public function getSearchEngine(): int
    {
        return $this->searchEngine;
    }

    public function getRabbitMQ(): int
    {
        return $this->rabbitmq;
    }

    public function getRedis(): int
    {
        return $this->redis;
    }
}