---
layout: page
title: Usage
permalink: /usage/
---

WriteGood is easy to use and has customization options.

## Creating an Instance

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

## Changing Tool Tip or Menu Text

```vala
public string passive_voice_menu_label { get; set; default = PASSIVE_VOICE_STR; }
public string weasel_word_menu_label { get; set; default = WEASEL_WORD_STR; }
public string weak_words_and_adverbs_menu_label { get; set; default = WEAK_WORD_STR; }
public string wordy_word_menu_label { get; set; default = WORDY_WORD_STR; }
public string lexical_illution_menu_label { get; set; default = LEXICAL_ILLUSION_STR; }
public string hard_sentence_menu_label { get; set; default = HARD_SENTENCE_STR; }
public string very_hard_sentence_menu_label { get; set; default = VERY_HARD_SENTENCE_STR; }

public string passive_voice_tooltip_message { get; set; default = PASSIVE_VOICE_STR; }
public string weasel_word_tooltip_message { get; set; default = WEASEL_WORD_STR; }
public string weak_words_and_adverbs_tooltip_message { get; set; default = WEAK_WORD_STR; }
public string wordy_word_tooltip_message { get; set; default = WORDY_WORD_STR; }
public string lexical_illution_tooltip_message { get; set; default = LEXICAL_ILLUSION_STR; }
public string hard_sentence_tooltip_message { get; set; default = HARD_SENTENCE_STR; }
public string very_hard_sentence_tooltip_message { get; set; default = VERY_HARD_SENTENCE_STR; }
```

Tool Tip suggestions or Menu Item text can be changed by setting the string for the corresponding style check. The menu items can be adjusted to take action (whether deleting words, or opening a style guide resource). The messages do not have to match.

#### Default strings

```vala
public const string PASSIVE_VOICE_STR = "Passive voice found, be active";
public const string WEASEL_WORD_STR = "Weasel word found, omit it";
public const string WEAK_WORD_STR = "Weak word found, be forceful";
public const string WORDY_WORD_STR = "Wordy word found, be direct";
public const string LEXICAL_ILLUSION_STR = "Repeating word found";
public const string HARD_SENTENCE_STR = "This sentence is hard to read";
public const string VERY_HARD_SENTENCE_STR = "This sentence is very hard to read";
```

## Menu Item Click Events

```vala
public signal void passive_voice_clicked ();
public signal void weasel_words_clicked ();
public signal void weak_words_and_adverbs_clicked ();
public signal void wordy_words_clicked ();
public signal void lexical_illusions_clicked ();
public signal void hard_sentences_clicked ();
```

WriteGood emits a signal whenever the user click on the menu item. This is useful for opening style resources or removing words/swapping a suggestion.

## Highlight or Underline

```vala
public WriteGoodChecker (bool underline = true, bool highlight = true);
```

By default, WriteGood will underline and highlight suggestions. In the constructor, underlining and highlighting can be adjusted.

## Running a Check

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

## Counts of Occurrences

```vala
public int passive_voice_count { get; set; default = 0; }
public int weasel_word_count { get; set; default = 0; }
public int weak_words_and_adverbs_count { get; set; default = 0; }
public int wordy_words_count { get; set; default = 0; }
public int lexical_illusions_count { get; set; default = 0; }
public int hard_sentence_count { get; set; default = 0; }
public int very_hard_sentence_count { get; set; default = 0; }
```

In some cases, action might not be suggested unless a certain threshold is met. WriteGood provides a count of the number of matches for each check.

This can be used for informing the writer that a certain number of instances were found, but no action is needed at this time.

## Detach or Turn Off WriteGood

```vala
checker.detach ();
```

Calling `detach ()` removes all WriteGood highlighting or underlining from the TextView. WriteGood will derefernce both the TextView and TextBuffer.