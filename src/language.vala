namespace WriteGood {
    public abstract class Language : Object {
        public abstract string[] weasel_words { get; protected set; }
        public abstract string[] passive_words { get; protected set; }
        public abstract string[] passive_future_words { get; protected set; }
        public abstract string[] adverbs_words { get; protected set; }
        public abstract string[] weak_words { get; protected set; }
        public abstract string[] wordy_words { get; protected set; }

        public virtual bool is_hard_sentence (string sentence) {
            string[] parts = sentence.chug ().chomp ().split_set (" \n", 0);
            return parts.length >= 14 && parts.length < 20;
        }

        public virtual bool is_very_hard_sentence (string sentence) {
            string[] parts = sentence.chug ().chomp ().split_set (" \n", 0);
            return parts.length >= 20;
        }
    }
}