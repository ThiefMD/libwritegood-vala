---
layout: page
title: Quick-Start
permalink: /quick-start/
---

### Using wraps

In the subprojects directory create `libwritegood.wrap`

```
[wrap-git]
directory=libwritegood
url=https://github.com/ThiefMD/libwritegood-vala.git
revision=master
```

In your `meson.build`, add a dependency:

```
writegood_dep = dependency('writegood-0.1', fallback : [ 'writegood', 'libwritegood_dep' ])
```

### Using Git-Submodules

```
git submodule add https://github.com/ThiefMD/libwritegood-vala.git src/writegood
```

In your `meson.build` add a dependency, or add the code paths to your sources.

```
executable(
    meson.project_name(),
    'src/writegood/src/language.vala',
    'src/writegood/src/writegood.vala',
    'src/writegood/src/en_us.vala',
    c_args: c_args,
    dependencies: [
        dependency('gobject-2.0'),
        dependency('gtksourceview-4'),
        dependency('gtk+-3.0')
    ],
    vala_args: [
        meson.source_root() + '/vapi/config.vapi'
    ],
    install : true
)
```

### Attach to the TextView or SourceView

```vala
var view = new Gtk.SourceView ();
buffer = new Gtk.SourceBuffer (null);
buffer.highlight_syntax = true;
view.set_buffer (buffer);

//
// Enable write-good
//
checker = new WriteGood.Checker ();
checker.set_language ("en_US");
checker.attach (view);

//
// WriteGood doesn't auto-check for changes, may be too compute heavy for large docs
// Probably don't do this, and use a Timeout, but yeah... just an example
//
buffer.changed.connect (() => {
    checker.recheck_all ();
});
```
