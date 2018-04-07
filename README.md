# ProjectLocator (ProLo)

Sick and tired of having to type project's location everytime I want to work on them. Basically, Project Locator will simply show a list of projects you have in config's ROOT property and navigate into them quickly. I tried to make the commands as short as possible.

This project uses zsh/&bash only (so far).

The following files help with the script:

​	`config`: contains a list of configuration items.

​		ROOT: set to the main project folder in which all your projects are contained.

​	`project` : contains a list of last 10 projects you used through `pro`

​	`last` : contains a string of the latest project path you used.



You can add tasks to `task` along with parameter `project:name` , 'name' being the project folder's name. ProLo will simply display the list of task everytime you want to see it. Just use `pro ta`.

## Commands

You will need to alias the script to run the script as 'pro'.
`alias pro=path/to/p.sh`

```bash
 $ pro            (show last 10 projects)
 $ pro a          (show list of all project in your $ROOT in ./project )
 $ pro l          (goto last project you selected, shows path in ./last)
 $ pro [0-9]      (if you know the number then, jump to the project in that number)
 $ pro [0-9] srcs (same as above, but also change to 'srcs' directory.)
 $ pro l srcs     (goto last project's 'srcs' directory.)
 $ pro ta         (shows latest project's tasks - depends on `task` program )
```
#### TODO:

  - add custom commands to each project folders and run to get bunch of repetitive stuffs done immediately. Like, `pro prepare` in an angular app will run `ng serve`, then open that project in my fav editor and then open my documentations in vim etc.
  - Read git branches and oldest commits in the main menu.
  - Linking with `task` cli.
    - usba(users should be able) to link project directory with task project tag.
    - a universal variable like `$pro` to let the users do this `task project:$pro I wan to do this`, always on when in the latest directory.
