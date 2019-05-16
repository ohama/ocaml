### How to build

You need [hugo](https://gohugo.io/) in order to build this site.

* hugo 0.54 (not 0.55)

How to build:

```
$ cd docsrc
$ hugo
$ rm -rf ../docs
$ mv docs ../
$ touch ../.nojekyll
```
