To install into $HOME:

```
( cd; curl -sL https://github.com/roobert/$REPOS/tarball/master | tar -xzv --strip-components 1 --exclude={README.md} | cut -d '/' -f 2- )
```

