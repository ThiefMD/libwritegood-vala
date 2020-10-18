---
layout: page
title: Usage
permalink: /usage/
---

WriteGood is easy to use and has customization options.

## Creating and Instance

```vala
var checker = new WriteGood.Checker ();
checker.set_language ("en_US");
checker.attach (view);
```

`new WriteGood.Checker ()` creates a new instance of WriteGood.

`checker.set_language ("en_US")` changes the language to US English.

`checker.attach (view)` attaches the WriteGood instance to the provided Gtk.TextView.

## Enabling or Disabling Checks

```vala
public bool check_passive_voice { get; set; default = true; }
public bool check_weasel_words { get; set; default = true; }
public bool check_weak_words_and_adverbs { get; set; default = true; }
public bool check_wordy_words { get; set; default = true; }
public bool check_lexical_illusions { get; set; default = true; }
public bool check_hard_sentences { get; set; default = true; }
```

The WriteGood instance exposes bools that disable and enable the different checks. By default, all the checks are true.

## Tool Tips or Menu?

```vala
public bool show_tooltip { get; set; default = false; }
public bool show_menu_item { get; set; default = true; }
```

By default, the user has to right-click on the highlighted text to learn what the issue is. This can be changed by setting `show_tooltip` to `true` and setting `show_menu_item` to `false`.

## Highlight or Underline

```vala
public WriteGoodChecker (bool underline = true, bool highlight = true);
```

By default, WriteGood will underline and highlight suggestions. In the constructor, underlining and highlighting can be adjusted.

### Running a Check

```vala
//
// WriteGood doesn't auto-check for changes, may be too compute heavy for large docs
// Probably don't do this, and use a Timeout, but yeah... just an example
//
buffer.changed.connect (() => {
    checker.recheck_all ();
});
```

`recheck_all ()` runs the enabled checks on the contents of the TextView buffer.

### Detach or Turn Off WriteGood

```vala
checker.detach ();
```

Calling `detach ()` removes all WriteGood highlighting or underlining from the TextView. WriteGood will derefernce both the TextView and TextBuffer.