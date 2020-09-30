using Gtk;
using Gdk;

public class HelloWriteGood : Gtk.Application {
    private Gtk.SourceView view;
    private Gtk.SourceBuffer buffer;
    private WriteGood.Checker checker;
    private TimedMutex scheduler;
    private const int TYPE_DELAY = 500;
    private const string SAMPLE_TEXT = """# Hello WriteGood

Write Good attempts to help you do better at writing. Perhaps it will, or maybe it won't.

The the thing it finds should hopefully help. A repeating word that, perhaps, doesn't belong?

Certain sentences might be too long or complicated or wordy, or maybe just downright confusing for some readers, so those sentences should probably be shortened.

Write Good scans for passive voice, wordy words, weak words, adverbs, lexical illusions (words typed twice in a row), and complex sentences.

Hope it's useful!

## Credits
 * [brford/writegood](https://github.com/btford/write-good)
 * [3 shell scripts to improve your writing, or "My Ph.D. advisor rewrote himself in bash."](http://matt.might.net/articles/shell-scripts-for-passive-voice-weasel-words-duplicates/)
 * [How I reverse-engineered the Hemingway Editor - a popular writing app - and built my own from a beach in Thailand](https://www.freecodecamp.org/news/https-medium-com-samwcoding-deconstructing-the-hemingway-app-8098e22d878d/)""";

    protected override void activate () {
        var window = new Gtk.ApplicationWindow (this);
        window.set_title ("WriteGood Example");
        window.set_default_size (800, 640);

        var preview_box = new Gtk.ScrolledWindow (null, null);
        scheduler = new TimedMutex (TYPE_DELAY);

        var manager = Gtk.SourceLanguageManager.get_default ();
        var language = manager.guess_language (null, "text/markdown");
        view = new Gtk.SourceView ();
        view.margin = 0;
        buffer = new Gtk.SourceBuffer.with_language (language);
        buffer.highlight_syntax = true;
        view.set_buffer (buffer);
        view.set_wrap_mode (Gtk.WrapMode.WORD);
        buffer.text = SAMPLE_TEXT;
        preview_box.add (view);

        //
        // Enable write-good
        //

        checker = new WriteGood.Checker ();
        checker.set_language ("en_US");
        checker.attach (view);

        buffer.changed.connect (rescan);

        window.add (preview_box);
        window.show_all ();
        checker.recheck_all ();
    }

    public void rescan () {
        if (scheduler.can_do_action ()) {
            Timeout.add (TYPE_DELAY, () => {
                debug ("\n===== rescan =====\n");
                checker.recheck_all ();
                return false;
            });
        }
    }

    public class TimedMutex {
        private bool can_action;
        private Mutex droptex;
        private int delay;

        public TimedMutex (int milliseconds_delay = 300) {
            if (milliseconds_delay < 100) {
                milliseconds_delay = 100;
            }

            delay = milliseconds_delay;
            can_action = true;
            droptex = Mutex ();
        }

        public bool can_do_action () {
            bool res = can_action;
            debug ("%s do action", res ? "CAN" : "CANNOT");

            if (can_action) {
                debug ("Acquiring lock");
                droptex.lock ();
                debug ("Lock acquired");
                can_action = false;
                Timeout.add (delay, clear_action);
                droptex.unlock ();
            }
            return res;
        }

        private bool clear_action () {
            droptex.lock ();
            can_action = true;
            droptex.unlock ();
            return false;
        }
    }

    public static int main (string[] args) {
        return new HelloWriteGood ().run (args);
    }
}