## Install

### 1. Clone magento's repository.

Example for ``MacOS``: ``~/Users/{username}/Sites/{magento root}``

### 2. Give a permission.

``sudo chmod 755 install.sh``

``sudo chmod 755 run.sh``

``sudo chmod 755 die.sh``

### 3. Link composer.
Make sure that composer's directory does not exist inside root folder.

``MacOS``:
``ln -s /Users/{username}/.composer composer``

``Linux``:
``ln -s /home/{username}/.config/composer composer``

### 4. Execute install script.

Bash ``./install.sh`` inside the root directory and follow the steps.

### 5. Server name.
Add a new line ``127.0.0.1 test.local`` to ``/etc/hosts``

### 6. Run docker.
Use ``run.sh`` and follow the steps.

### 7. Stop docker.
Use ``die.sh``