## Install

### 1. Clone magento's repository

Example for ``MacOS``: ``~/Users/{username}/Sites/{magento root}``

### 2. Give a permission for shell scripts

``sudo chmod 755 install.sh``

``sudo chmod 755 switch.sh``

``sudo chmod 755 restart.sh``

### 3. Execute install script

Bash ``./install.sh`` inside the root directory and follow the steps.

1. Define a project name, example: ``test``
2. Define a server name, example: ``test.local``
3. Define a full path to the project, example: ``~/Users/{username}/Sites/{magento root}``
4. Select a version of PHP

### 4. Server name
Add a new line ``127.0.0.1 test.local`` to ``/etc/hosts``

### 5. Link composer

Make sure that directory composer doesn't exist in root folder. 

Example MacOS:
``ln -s /Users/{username}/.composer composer``

### 6. Run docker
Inside the root directory run ``docker-compose up -d``
