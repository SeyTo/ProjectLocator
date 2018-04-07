# ProjectLocator (ProLo)

Project Locator will simply show a list of project you have in config's ROOT property. 

This project uses zsh/&bash only (so far).

## commands

```bash
 $ pro     (get last 10 projects)
 $ pro a   (show list of all project)
 $ pro l   (goto last project you selected)
 $ pro [0-9] (if you know the number then, jump to the project in that number)
 $ pro [0-9] srcs (same as above, but also change to 'srcs' directory.)
 $ pro l srcs    (goto last project's 'srcs' directory.)
```
TODO:
  - add custom commands to each project folders and run to get bunch of repetitive stuffs done immediately. Like, `pro prepare` in an angular app will run `ng serve`, then open that project in my fav editor and then open my documentations in vim etc.
  - read git branches and latest commits in the main menu
  - read todo list relating to this project from `task` cli.
    - add task cli project keyword to config and read it when navigating to project.
    - usba(users should be able) to link project directory with task project tag.
