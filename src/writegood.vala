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
        private Mutex checking;
        private string checking_copy;
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

        public signal void passive_voice_clicked ();
        public signal void weasel_words_clicked ();
        public signal void weak_words_and_adverbs_clicked ();
        public signal void wordy_words_clicked ();
        public signal void lexical_illusions_clicked ();
        public signal void hard_sentences_clicked ();

        public int passive_voice_count { get; set; default = 0; }
        public int weasel_word_count { get; set; default = 0; }
        public int weak_words_and_adverbs_count { get; set; default = 0; }
        public int wordy_words_count { get; set; default = 0; }
        public int lexical_illusions_count { get; set; default = 0; }
        public int hard_sentence_count { get; set; default = 0; }
        public int very_hard_sentence_count { get; set; default = 0; }

        //
        // String constants and ability to change messaging
        //

        public const string PASSIVE_VOICE_STR = "Passive voice found, be active";
        public const string WEASEL_WORD_STR = "Weasel word found, omit it";
        public const string WEAK_WORD_STR = "Weak word found, be forceful";
        public const string WORDY_WORD_STR = "Wordy word found, be direct";
        public const string LEXICAL_ILLUSION_STR = "Repeating word found";
        public const string HARD_SENTENCE_STR = "This sentence is hard to read";
        public const string VERY_HARD_SENTENCE_STR = "This sentence is very hard to read";

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

        private bool showing_tooltips = false;
        public bool show_tooltip { 
            get {
                return showing_tooltips;
            }
            set
            {
                if (value && view != null) {
                    view.set_has_tooltip (true);
                    view.query_tooltip.connect (handle_tooltip);
                } else if (view != null) {
                    view.query_tooltip.disconnect (handle_tooltip);
                }
                showing_tooltips = value;
            }
        }
        public bool show_menu_item { get; set; default = true; }

        public Checker (bool underline = true, bool highlight = true) {
            c_underline = underline;
            c_highlight = highlight;
            checking = Mutex ();
        }

        public void recheck_all () {
            if (view == null || buffer == null || language == null) {
                return;
            }

            if (!checking.trylock ()) {
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
            checking_copy = buffer.get_text (start, end, true);

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

            checking_copy = "";

            checking.unlock ();
        }

        private void find_complex_sentences () {
            try {
                Regex check_sentences = new Regex ("\\s+([^\\.\\!\\?\\n]+[\\.\\!\\?\\n\\R])", RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                hard_sentence_count = 0;
                if (check_sentences.match_full (checking_copy, checking_copy.length, 0, RegexMatchFlags.BSR_ANYCRLF | RegexMatchFlags.NEWLINE_ANYCRLF, out match_info)) {
                    do {
                        hard_sentence_count++;
                        for (int i = 1; i < match_info.get_match_count (); i++) {
                            string sentence = match_info.fetch (i);
                            int start_pos, end_pos;
                            bool highlight = match_info.fetch_pos (i, out start_pos, out end_pos);

                            if (highlight) {
                                start_pos = checking_copy.char_count (start_pos);
                                end_pos = checking_copy.char_count (end_pos);
                                Gtk.TextIter start, end;
                                buffer.get_iter_at_offset (out start, start_pos);
                                buffer.get_iter_at_offset (out end, end_pos);
                                if (!start.starts_sentence ()) {
                                    start.backward_word_start ();
                                }

                                if (end.inside_sentence ()) {
                                    end.backward_sentence_start ();
                                    if (end.starts_word ()) {
                                        end.backward_char ();
                                    }
                                }

                                // Undo if we go too far
                                if (end.get_offset () - start.get_offset () < (sentence.length - 4)) {
                                    buffer.get_iter_at_offset (out start, start_pos);
                                    buffer.get_iter_at_offset (out end, end_pos);
                                }

                                if (language.is_very_hard_sentence (sentence)) {
                                    buffer.apply_tag (tag_very_hard_sentences, start, end);
                                }
                                if (language.is_hard_sentence (sentence)) {
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
                Regex check_words = new Regex ("(\\s*)([^\\.\\?!:\"\\s]+)([\\.\\?!:\"\\s]*)", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                Regex is_word = new Regex ("\\w+", RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                lexical_illusions_count = 0;
                if (check_words.match_full (checking_copy, checking_copy.length, 0, 0, out match_info)) {
                    if (match_info == null) {
                        return;
                    }

                    string last_match = "";
                    do {
                        if (match_info.get_match_count () >= 2) {
                            string word = match_info.fetch (2);

                            if (word != null && word != "" && word.down () == last_match) {
                                int start_pos, end_pos;
                                bool highlight = match_info.fetch_pos (2, out start_pos, out end_pos);

                                if (highlight) {
                                    lexical_illusions_count++;
                                    start_pos = checking_copy.char_count (start_pos);
                                    end_pos = checking_copy.char_count (end_pos);
                                    Gtk.TextIter start, end;
                                    buffer.get_iter_at_offset (out start, start_pos);
                                    buffer.get_iter_at_offset (out end, end_pos);
                                    buffer.apply_tag (tag_lexical_illusions, start, end);
                                }
                            }
                            if (word != null && word != "" && is_word.match (word, RegexMatchFlags.NOTEMPTY)) {
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
                wordy_words_count = 0;
                if (wordy_words.match_full (checking_copy, checking_copy.length, 0, 0, out match_info)) {
                    int matches = 0;
                    highlight_results (match_info, tag_wordy_words, out matches);
                    wordy_words_count = matches;
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
                weak_words_and_adverbs_count = 0;
                if (weak_words.match_full (checking_copy, checking_copy.length, 0, 0, out match_info)) {
                    int matches = 0;
                    highlight_results (match_info, tag_weak_words, out matches);
                    weak_words_and_adverbs_count = matches;
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
                weasel_word_count = 0;
                if (weasel_words.match_full (checking_copy, checking_copy.length, 0, 0, out match_info)) {
                    int matches = 0;
                    highlight_results (match_info, tag_weasel_words, out matches);
                    weasel_word_count = matches;
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
                Regex passive_voice = new Regex ("\\b(am|are|were|being|is|been|was|be)\\b\\s*([\\w]+ed|" + string.joinv ("|", language.passive_words) + ")\\b", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                MatchInfo match_info;
                passive_voice_count = 0;
                if (passive_voice.match_full (checking_copy, checking_copy.length, 0, 0, out match_info)) {
                    int matches = 0;
                    highlight_results (match_info, tag_passive, out matches);
                    passive_voice_count += matches;
                }

                Regex passive_future = new Regex ("\\b(will)\\b\\s*(" + string.joinv ("|", language.passive_words) + string.joinv ("|", language.passive_future_words) + ")\\b", RegexCompileFlags.MULTILINE | RegexCompileFlags.CASELESS, 0);
                if (passive_future.match_full (checking_copy, checking_copy.length, 0, 0, out match_info)) {
                    int matches = 0;
                    highlight_results (match_info, tag_passive, out matches);
                    passive_voice_count += matches;
                }
            } catch (Error e) {
                warning ("Could not identify passive voice: %s", e.message);
            }
        }

        private void highlight_results (MatchInfo match_info, Gtk.TextTag marker, out int count, bool highlight_all = true) throws Error {
            if (marker == null) {
                return;
            }
            count = 0;
            do {
                count++;
                int start_pos, end_pos;
                bool highlight = false;
                if (highlight_all) {
                    highlight = match_info.fetch_pos (0, out start_pos, out end_pos);
                    string word = match_info.fetch (0);
                    start_pos = checking_copy.char_count (start_pos);
                    end_pos = checking_copy.char_count (end_pos);

                    if (word != null && highlight && word.chomp ().chug () != "" && word.chomp ().chug () != "y") {
                        debug ("%s: %s", marker.name, word);
                        Gtk.TextIter start, end;
                        buffer.get_iter_at_offset (out start, start_pos);
                        buffer.get_iter_at_offset (out end, end_pos);

                        buffer.remove_all_tags (start, end);
                        buffer.apply_tag (marker, start, end);
                    }
                } else {
                    for (int i = 1; i < match_info.get_match_count (); i++) {
                        highlight = match_info.fetch_pos (i, out start_pos, out end_pos);
                        string word = match_info.fetch (i);
                        start_pos = checking_copy.char_count (start_pos);
                        end_pos = checking_copy.char_count (end_pos);

                        if (word != null && highlight && word.chomp ().chug () != "" && word.chomp ().chug () != "y") {
                            debug ("%s: %s", marker.name, word);
                            Gtk.TextIter start, end;
                            buffer.get_iter_at_offset (out start, start_pos);
                            buffer.get_iter_at_offset (out end, end_pos);

                            buffer.remove_all_tags (start, end);
                            buffer.apply_tag (marker, start, end);
                        }
                    }
                }
            } while (match_info.next ());
        }

        private void populate_menu (Gtk.TextView source, Gtk.Menu menu) {
            if (!show_menu_item) {
                return;
            }

            if (buffer == null || view == null || tag_passive == null) {
                return;
            }

            Gtk.TextMark cursor = buffer.get_insert ();
            Gtk.TextIter iter_start;
            buffer.get_iter_at_mark (out iter_start, cursor);

            bool separator = false;

            if (iter_start.has_tag (tag_passive)) {
                menu.add (new Gtk.SeparatorMenuItem ());
                separator = true;
                Gtk.MenuItem passive_voice = new Gtk.MenuItem.with_label (passive_voice_menu_label);
                menu.add (passive_voice);
                passive_voice.activate.connect (() => {
                    passive_voice_clicked ();
                });
            }

            if (iter_start.has_tag (tag_weasel_words)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem weasel_word = new Gtk.MenuItem.with_label (weasel_word_menu_label);
                menu.add (weasel_word);
                weasel_word.activate.connect (() => {
                    weasel_words_clicked ();
                });
            }

            if (iter_start.has_tag (tag_weak_words)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem weak_word = new Gtk.MenuItem.with_label (weak_words_and_adverbs_menu_label);
                menu.add (weak_word);
                weak_word.activate.connect (() => {
                    weak_words_and_adverbs_clicked ();
                });
            }

            if (iter_start.has_tag (tag_wordy_words)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem wordy_word = new Gtk.MenuItem.with_label (wordy_word_menu_label);
                menu.add (wordy_word);
                wordy_word.activate.connect (() => {
                    wordy_words_clicked ();
                });
            }

            if (iter_start.has_tag (tag_lexical_illusions)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem lexical_illusion = new Gtk.MenuItem.with_label (lexical_illution_menu_label);
                menu.add (lexical_illusion);
                lexical_illusion.activate.connect (() => {
                    lexical_illusions_clicked ();
                });
            }

            if (iter_start.has_tag (tag_hard_sentences)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem hard_sentence = new Gtk.MenuItem.with_label (hard_sentence_menu_label);
                menu.add (hard_sentence);
                hard_sentence.activate.connect (() => {
                    hard_sentences_clicked ();
                });
            }

            if (iter_start.has_tag (tag_very_hard_sentences)) {
                if (!separator) {
                    menu.add (new Gtk.SeparatorMenuItem ());
                    separator = true;
                }

                Gtk.MenuItem very_hard_sentence = new Gtk.MenuItem.with_label (very_hard_sentence_menu_label);
                menu.add (very_hard_sentence);
                very_hard_sentence.activate.connect (() => {
                    hard_sentences_clicked ();
                });
            }

            menu.show_all ();
        }

        public bool handle_tooltip (int x, int y, bool keyboard_tooltip, Gtk.Tooltip tooltip) {
            if (!showing_tooltips) {
                return true;
            }

            if (buffer == null || view == null || tag_passive == null) {
                return true;
            }

            Gtk.TextIter? iter;
            if (keyboard_tooltip) {
                int offset = buffer.cursor_position;
                buffer.get_iter_at_offset (out iter, offset);
            } else {
                int m_x, m_y, trailing;
                view.window_to_buffer_coords (Gtk.TextWindowType.TEXT, x, y, out m_x, out m_y);
                view.get_iter_at_position (out iter, out trailing, m_x, m_y);
            }

            if (iter != null) {
                string message = "";
                if (iter.has_tag (tag_passive)) {
                    message = passive_voice_tooltip_message;
                }

                if (iter.has_tag (tag_weasel_words)) {
                    message = weasel_word_tooltip_message;
                }

                if (iter.has_tag (tag_weak_words)) {
                    message = weak_words_and_adverbs_tooltip_message;
                }

                if (iter.has_tag (tag_wordy_words)) {
                    message = wordy_word_tooltip_message;
                }

                if (iter.has_tag (tag_lexical_illusions)) {
                    message = lexical_illution_tooltip_message;
                }

                if (iter.has_tag (tag_hard_sentences)) {
                    message = hard_sentence_tooltip_message;
                }

                if (iter.has_tag (tag_very_hard_sentences)) {
                    message = very_hard_sentence_tooltip_message;
                }

                if (message == "") {
                    return false;
                } else {
                    tooltip.set_markup (message);
                }
            } else {
                return false;
            }

            return true;
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

            if (showing_tooltips) {
                view.query_tooltip.connect (handle_tooltip);
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
            if (buffer == null || view == null) {
                return;
            }

            view.populate_popup.disconnect (populate_menu);

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

            buffer.remove_tag (tag_very_hard_sentences, start, end);
            buffer.tag_table.remove (tag_very_hard_sentences);
            tag_very_hard_sentences = null;

            if (showing_tooltips) {
                view.query_tooltip.disconnect (handle_tooltip);
            }

            view = null;
            buffer = null;
        }

        public static string[] get_language_list () {
            string[] languages = { "en_US" };

            return languages;
        }
    }
}
