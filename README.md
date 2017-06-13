# git-mv-accross-repos
## Preserve Git histories

Example: Move folderA from repoA to repoB and rename to folderB but keep the Git histories

    Before: 
      Layout:
          src/
              main/
                  folderA/
                          ...
    After: 
      Layout:
          src/
              test/
                  folderB/
                          ...

Usage: ./git-accross-mv.sh repoA/src/main/folderA reposB/src/test/folderB
