<?php

declare(strict_types=1);

namespace Console;

use Throwable;
use Symfony\Component\Console\Application;
use Symfony\Component\Console\Input\StringInput;
use Console\Utils\Output;
use Console\Command\Stream;

class App
{
    private const STREAM_COMMAND = 'home';

    private Application $application;

    public function __construct(
    ) {
        $this->application = new Application();
    }

    /**
     * @return void
     *
     * @throws Throwable
     */
    public function launch(): void
    {
        $streamCommand = new Stream();
        $this->application->add($streamCommand);
        $this->application->doRun(
            new StringInput($streamCommand->getName()),
            new Output()
        );
    }
}