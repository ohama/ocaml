## ocaml-build

    $ ./deploy.sh
    
### config.toml

    ...
    baseURL = "https://ohama.github.io/ocaml"
    publishDir = "docs"
    ...
    
### deploy.sh

    rm -rf docs
    hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

    # Go To Public folder
    cd public

    rm -rf docs
    mv ../docs .

    # Add changes to git.
    git add .
    
### .gitmodules

    [submodule "public"]
      path = public
      url = git@github.com:ohama/ocaml.git

### attachment

* hugo 0.54
* .nojekyll in root dir

### logo.html

* inkscape
  * font: "The Brandy"
  * path: object to path
* ohama7.svg
  * remove header
  * => ohama71.svg
