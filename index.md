---
layout: page
title: WriteGood
subtitle: It's like spellcheck for style
---

## Welcome to WriteGood

libwritegood-vala is a port of [btford's write-good](https://github.com/btford/write-good) to [Vala](https://wiki.gnome.org/Projects/Vala).

![Write-Good highlighting passive voice](/images/write-good.png)

WriteGood can attach to a [Gtk.TextView](https://valadoc.org/gtk4/Gtk.TextView.html) or [Gtk.SourceView](https://valadoc.org/gtksourceview-4/Gtk.SourceView.html) to provide writing suggestions.

## Writing Suggestions

WriteGood detects and highlights

 * [Passive Voice](https://en.wikipedia.org/wiki/Passive_voice)
 * [Weasel Words](https://en.wikipedia.org/wiki/Weasel_word)
 * [Weak Words](https://expresswriters.com/50-weak-words-and-phrases-to-cut-out-of-your-blogging/)
 * [Common Wordiness](https://bethune.yorku.ca/writing/wordiness/) (Wordy Words)
 * Repeating Words (Lexical Illusions)
 * Hard Sentences (sentences containing 14 or more words)
 * Very Hard Sentences (sentences containing 20 or more words)
