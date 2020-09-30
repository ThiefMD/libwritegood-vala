const string GETTEXT_PACKAGE = "...";

namespace WriteGood {
    public class Checker {
        private Gtk.TextView view;
        private Gtk.TextBuffer buffer;
        private Gtk.TextTag tag_passive;
        private Gtk.TextTag tag_weasel_words;
        private Gtk.TextTag tag_weak_words;
        private Gtk.TextTag tag_wordy_words;
        private Gtk.TextTag tag_lexical_illusions;
        private Gtk.TextTag tag_hard_sentences;
        private Gtk.TextTag tag_very_hard_sentences;
        private Language language;
        private string language_string;

        private bool c_underline;
        private bool c_highlight;

        public bool check_passive_voice { get; set; default = true; }
        public bool check_weasel_words { get; set; default = true; }
        public bool check_weak_words_and_adverbs { get; set; default = true; }
        public bool check_wordy_words { get; set; default = true; }
        public bool check_lexical_illusions { get; set; default = true; }
        public bool check_hard_sentences { get; set; default = true; }

        public Checker (bool underline = true, bool hightlight = true) {
            c_underline = underline;
            c_highlight = hightlight;
        }

        public void recheck_all () {
            if (view == null || buffer == null || language == null) {
                return;
            }

            // Remove any previous tags
            Gtk.TextIter start, end;
            buffer.get_bounds (out start, out end);
            buffer.remove_tag (tag_passive, start, end);
            buffer.remove_tag (tag_weasel_words, start, end);
            buffer.remove_tag (tag_weak_words, start, end);
            buffer.remove_tag (tag_wordy_words, start, end);
            buffer.remove_tag (tag_hard_sentences, start, end);
            buffer.remove_tag (tag_very_hard_sentences, start, end);
            buffer.remove_tag (tag_lexical_illusions, start, end);

            if (check_hard_sentences) {
                find_complex_sentences ();
            }

            if (check_weak_words_and_adverbs) {
                find_weak_words ();
            }

            if (check_wordy_words) {
                find_wordy_words ();
            }

            if (check_weasel_words) {
                find_weasel_words ();
            }

            if (check_passive_voice) {
                find_passive_voice ();
            }

            if (check_lexical_illusions) {
                find_lexical_illusions ();
            }
        }

        private void find_complex_sentences () {
            try {
                Regex check_sentences = new Regex ("([^\\.\\!\\?]*)[\\.\\!\\?]", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                if (check_sentences.match_full (buffer.text, buffer.text.length, 0, 0, out match_info)) {
                    do {
                        for (int i = 1; i < match_info.get_match_count (); i++) {
                            string sentence = match_info.fetch (i);
                            if (language.is_very_hard_sentence (sentence)) {
                                int start_pos, end_pos;
                                bool highlight = match_info.fetch_pos (i, out start_pos, out end_pos);

                                if (highlight) {
                                    Gtk.TextIter start, end;
                                    buffer.get_iter_at_offset (out start, start_pos);
                                    buffer.get_iter_at_offset (out end, end_pos);
                                    buffer.apply_tag (tag_very_hard_sentences, start, end);
                                }
                            }
                            if (language.is_hard_sentence (sentence)) {
                                int start_pos, end_pos;
                                bool highlight = match_info.fetch_pos (i, out start_pos, out end_pos);

                                if (highlight) {
                                    Gtk.TextIter start, end;
                                    buffer.get_iter_at_offset (out start, start_pos);
                                    buffer.get_iter_at_offset (out end, end_pos);
                                    buffer.apply_tag (tag_hard_sentences, start, end);
                                }
                            }
                        }
                    } while (match_info.next ());
                }
            } catch (Error e) {
                warning ("Could not find complex sentences: %s", e.message);
            }
        }

        private void find_lexical_illusions () {
            if (view == null || buffer == null) {
                return;
            }

            try {
                Regex check_words = new Regex ("(\\s*)([^\\s]+)", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                Regex is_word = new Regex ("\\w+", RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                if (check_words.match_full (buffer.text, buffer.text.length, 0, 0, out match_info)) {
                    if (match_info == null) {
                        return;
                    }

                    string last_match = "";
                    do {
                        if (match_info.get_match_count () >= 2) {
                            string word = match_info.fetch (2);

                            if (is_word.match (word) && word.down () == last_match) {
                                int start_pos, end_pos;
                                bool highlight = match_info.fetch_pos (2, out start_pos, out end_pos);

                                if (highlight) {
                                    Gtk.TextIter start, end;
                                    buffer.get_iter_at_offset (out start, start_pos);
                                    buffer.get_iter_at_offset (out end, end_pos);
                                    buffer.apply_tag (tag_lexical_illusions, start, end);
                                }
                            }
                            if (is_word.match (word)) {
                                last_match = word.down ();
                            }
                        }
                    } while (match_info.next ());
                }
            } catch (Error e) {
                warning ("Could not identify lexical illusions: %s", e.message);
            }
        }

        private void find_wordy_words () {
            if (view == null || buffer == null) {
                return;
            }

            try {
                Regex wordy_words = new Regex ("\\b(" + string.joinv("|", language.wordy_words) + ")\\b", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                if (wordy_words.match_full (buffer.text, buffer.text.length, 0, 0, out match_info)) {
                    highlight_results (match_info, tag_wordy_words);
                }
            } catch (Error e) {
                warning ("Could not identify wordy words: %s", e.message);
            }
        }

        private void find_weak_words () {
            if (view == null || buffer == null) {
                return;
            }

            try {
                Regex weak_words = new Regex ("\\b((" + string.joinv("|", language.adverbs_words) + ")(y)|(" + string.joinv("|", language.weak_words) + "))\\b", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                if (weak_words.match_full (buffer.text, buffer.text.length, 0, 0, out match_info)) {
                    
                    highlight_results (match_info, tag_weak_words);
                }
            } catch (Error e) {
                warning ("Could not identify weak words: %s", e.message);
            }
        }

        private void find_weasel_words () {
            if (view == null || buffer == null) {
                return;
            }

            try {
                Regex weasel_words = new Regex ("\\b(" + string.joinv("|", language.weasel_words) + ")\\b", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                if (weasel_words.match_full (buffer.text, buffer.text.length, 0, 0, out match_info)) {
                    highlight_results (match_info, tag_weasel_words);
                }
            } catch (Error e) {
                warning ("Could not identify weasel words: %s", e.message);
            }
        }

        private void find_passive_voice () {
            if (view == null || buffer == null) {
                return;
            }

            try {
                Regex passive_voice = new Regex ("\\b(am|are|were|being|is|been|was|be)\\b\\s*([\\w]+ed|" + string.joinv("|", language.passive_words) + ")\\b", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                if (passive_voice.match_full (buffer.text, buffer.text.length, 0, 0, out match_info)) {
                    highlight_results (match_info, tag_passive);
                }
            } catch (Error e) {
                warning ("Could not identify passive voice: %s", e.message);
            }
        }

        private void highlight_results (MatchInfo match_info, Gtk.TextTag marker) throws Error {
            do {
                int start_pos, end_pos;
                bool highlight = false;
                for (int i = 1; i < match_info.get_match_count (); i++) {
                    highlight = match_info.fetch_pos (i, out start_pos, out end_pos);

                    if (highlight) {
                        Gtk.TextIter start, end;
                        buffer.get_iter_at_offset (out start, start_pos);
                        buffer.get_iter_at_offset (out end, end_pos);
                        buffer.remove_all_tags (start, end);
                        buffer.apply_tag (marker, start, end);
                    }
                }
            } while (match_info.next ());
        }

        private void populate_menu (Gtk.TextView source, Gtk.Menu menu) {
            Gtk.TextMark cursor = buffer.get_insert ();
            Gtk.TextIter iter_start;
            buffer.get_iter_at_mark (out iter_start, cursor);

            bool separator = false;

            if (iter_start.has_tag (tag_passive)) {
                menu.add (new Gtk.SeparatorMenuItem ());
                separator = true;
                Gtk.MenuItem passive_voice = new Gtk.MenuItem.with_label (_("Passive voice found, be active"));
                menu.add (passive_voice);
                menu.show_all ();
            }

            if (iter_start.has_tag (tag_weasel_words)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem weasel_word = new Gtk.MenuItem.with_label (_("Weasel word found, omit it"));
                menu.add (weasel_word);
            }

            if (iter_start.has_tag (tag_weak_words)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem weak_word = new Gtk.MenuItem.with_label (_("Weak word found, be forceful"));
                menu.add (weak_word);
            }

            if (iter_start.has_tag (tag_wordy_words)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem wordy_word = new Gtk.MenuItem.with_label (_("Wordy word found, be direct"));
                menu.add (wordy_word);
            }

            if (iter_start.has_tag (tag_lexical_illusions)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem lexical_illusion = new Gtk.MenuItem.with_label (_("Repeating word found"));
                menu.add (lexical_illusion);
            }

            if (iter_start.has_tag (tag_hard_sentences)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem hard_sentence = new Gtk.MenuItem.with_label (_("This sentence is hard to read"));
                menu.add (hard_sentence);
            }

            if (iter_start.has_tag (tag_very_hard_sentences)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem very_hard_sentence = new Gtk.MenuItem.with_label (_("This sentence very is hard to read"));
                menu.add (very_hard_sentence);
            }

            menu.show_all ();
        }

        public bool attach (Gtk.TextView textview) {
            if (textview == null) {
                return false;
            }

            view = textview;
            buffer = view.get_buffer ();
            if (buffer == null) {
                view = null;
                return false;
            }

            if (language == null) {
                set_language("en_US");
            }

            view.destroy.connect (detach);
            view.populate_popup.connect (populate_menu);

            // Passive words underline green
            tag_passive = buffer.create_tag ("passive_voice", "underline", Pango.Underline.ERROR, null);
            if (c_underline) {
                tag_passive.underline_rgba = Gdk.RGBA () { red = 0.0468, green = 0.5151, blue = 0.4381, alpha = 1.0 };
            }
            if (c_highlight) {
                tag_passive.background_rgba = Gdk.RGBA () { red = 0.0468, green = 0.5151, blue = 0.4381, alpha = 1.0 };
                tag_passive.foreground_rgba = Gdk.RGBA () { red = 0.9, green = 0.9, blue = 0.9, alpha = 1.0 };
            }

            // Weasel words in yellow
            tag_weasel_words = buffer.create_tag ("weasel_word", "underline", Pango.Underline.ERROR, null);
            if (c_underline) {
                tag_weasel_words.underline_rgba = Gdk.RGBA () { red = 0.4892, green = 0.3851, blue = 0.1257, alpha = 1.0 };
            }
            if (c_highlight) {
                tag_weasel_words.background_rgba = Gdk.RGBA () { red = 0.4892, green = 0.3851, blue = 0.1257, alpha = 1.0 };
                tag_weasel_words.foreground_rgba = Gdk.RGBA () { red = 0.9, green = 0.9, blue = 0.9, alpha = 1.0 };
            }

            // Weak words and adverbs
            tag_weak_words = buffer.create_tag ("weak_word", "underline", Pango.Underline.ERROR, null);
            if (c_underline) {
                tag_weak_words.underline_rgba = Gdk.RGBA () { red = 0.1263, green = 0.3242, blue = 0.5495, alpha = 1.0 };
            }
            if (c_highlight) {
                tag_weak_words.background_rgba = Gdk.RGBA () { red = 0.1263, green = 0.3242, blue = 0.5495, alpha = 1.0 };
                tag_weak_words.foreground_rgba = Gdk.RGBA () { red = 0.9, green = 0.9, blue = 0.9, alpha = 1.0 };
            }

            // Wordy words
            tag_wordy_words = buffer.create_tag ("wordy_word", "underline", Pango.Underline.ERROR, null);
            if (c_underline) {
                tag_wordy_words.underline_rgba = Gdk.RGBA () { red = 0.3257, green = 0.1629, blue = 0.5114, alpha = 1.0 };
            }
            if (c_highlight) {
                tag_wordy_words.background_rgba = Gdk.RGBA () { red = 0.3257, green = 0.1629, blue = 0.5114, alpha = 1.0 };
                tag_wordy_words.foreground_rgba = Gdk.RGBA () { red = 0.9, green = 0.9, blue = 0.9, alpha = 1.0 };
            }

            // Lexical Illusions
            tag_lexical_illusions = buffer.create_tag ("lexical_illustion", "underline", Pango.Underline.ERROR, null);
            if (c_underline) {
                tag_lexical_illusions.underline_rgba = Gdk.RGBA () { red = 0.6115, green = 0.2878, blue = 0.1007, alpha = 1.0 };
            }
            if (c_highlight) {
                tag_lexical_illusions.background_rgba = Gdk.RGBA () { red = 0.6115, green = 0.2878, blue = 0.1007, alpha = 1.0 };
                tag_lexical_illusions.foreground_rgba = Gdk.RGBA () { red = 0.9, green = 0.9, blue = 0.9, alpha = 1.0 };
            }

            // Hard sentences
            tag_hard_sentences = buffer.create_tag ("hard_sentence", "underline", Pango.Underline.ERROR, null);
            if (c_underline) {
                tag_hard_sentences.underline_rgba = Gdk.RGBA () { red = 0.3373, green = 0.2929, blue = 0.3698, alpha = 1.0 };
            }
            if (c_highlight) {
                tag_hard_sentences.background_rgba = Gdk.RGBA () { red = 0.3373, green = 0.2929, blue = 0.3698, alpha = 1.0 };
                tag_hard_sentences.foreground_rgba = Gdk.RGBA () { red = 0.9, green = 0.9, blue = 0.9, alpha = 1.0 };
            }
            tag_very_hard_sentences = buffer.create_tag ("very_hard_sentence", "underline", Pango.Underline.ERROR, null);
            if (c_underline) {
                tag_very_hard_sentences.underline_rgba = Gdk.RGBA () { red = 0.478, green = 0.0, blue = 0.0, alpha = 1.0 };
            }
            if (c_highlight) {
                tag_very_hard_sentences.background_rgba = Gdk.RGBA () { red = 0.478, green = 0.0, blue = 0.0, alpha = 1.0 };
                tag_very_hard_sentences.foreground_rgba = Gdk.RGBA () { red = 0.9, green = 0.9, blue = 0.9, alpha = 1.0 };
            }

            return true;
        }

        public void set_language (string lang) {
            switch (lang.down ()) {
                case "en_us":
                default:
                    language = new USEnglish ();
                    language_string = "en_US";
                    break;
            }
        }

        public string get_language () {
            return language_string;
        }

        public void detach () {
            Gtk.TextIter start, end;
            buffer.get_bounds (out start, out end);

            buffer.remove_tag (tag_passive, start, end);
            buffer.tag_table.remove (tag_passive);
            tag_passive = null;

            buffer.remove_tag (tag_weasel_words, start, end);
            buffer.tag_table.remove (tag_weasel_words);
            tag_weasel_words = null;

            buffer.remove_tag (tag_weak_words, start, end);
            buffer.tag_table.remove (tag_weak_words);
            tag_weak_words = null;

            buffer.remove_tag (tag_wordy_words, start, end);
            buffer.tag_table.remove (tag_wordy_words);
            tag_wordy_words = null;

            buffer.remove_tag (tag_lexical_illusions, start, end);
            buffer.tag_table.remove (tag_lexical_illusions);
            tag_lexical_illusions = null;

            buffer.remove_tag (tag_hard_sentences, start, end);
            buffer.tag_table.remove (tag_hard_sentences);
            tag_hard_sentences = null;

            view = null;
            buffer = null;
        }

        public static string[] get_language_list () {
            string[] languages = { "en_US" };

            return languages;
        }
    }
}
