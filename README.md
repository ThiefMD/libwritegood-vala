# libwritegood

A port of [write good](https://github.com/btford/write-good), [3 shell scripts to improve your writing, or "My Ph.D. advisor rewrote himself in bash."](http://matt.might.net/articles/shell-scripts-for-passive-voice-weasel-words-duplicates), and [How I reverse-engineered the Hemingway Editor - a popular writing app - and built my own from a beach in Thailand](https://www.freecodecamp.org/news/https-medium-com-samwcoding-deconstructing-the-hemingway-app-8098e22d878d) for Gtk TextView.

## Languages

Currently, we have:

```
en_US
```

## Requirements

### Ubuntu

```
meson
ninja-build
valac
cmake
libgtk-3-dev
```

### Fedora

```
vala
meson
ninja-build
cmake
gtk3-devel
```

## Usage

If your build system is meson, we recommend using [the wrap depenency system](https://mesonbuild.com/Wrap-dependency-system-manual.html)

###  writegood.wrap
```
[wrap-git]
directory=libwritegood
url=https://github.com/ThiefMD/libwritegood-vala.git
revision=master
```

Place the `writegood.wrap` in subprojects directory in your project.

In your meson.build, add:

```
writegood_dep = dependency('writegood-0.1', fallback : [ 'writegood', 'libwritegood_dep' ])
```

Then add writegood_dep to your dependencies.
