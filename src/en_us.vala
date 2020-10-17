namespace WriteGood {
    public class USEnglish : Language {
        public override string[] weasel_words { get; protected set; }
        public override string[] passive_words { get; protected set; }
        public override string[] passive_future_words { get; protected set; }
        public override string[] adverbs_words { get; protected set; }
        public override string[] weak_words { get; protected set; }
        public override string[] wordy_words { get; protected set; }

        public USEnglish () {
            weasel_words = {
                "are a number",
                "clearly",
                "actually",
                "completely",
                "exceedingly",
                "excellent",
                "extremely",
                "fairly",
                "few",
                "huge",
                "interestingly",
                "is a number",
                "largely",
                "many",
                "mostly",
                "obviously",
                "quite",
                "relatively",
                "remarkably",
                "several",
                "significantly",
                "substantially",
                "surprisingly",
                "suddenly",
                "tiny",
                "usually",
                "various",
                "vast",
                "very",
                "some people",
                "most people",
                "research shows",
                "experts say"
            };

            wordy_words = {
                "a number of",
                "abundance",
                "accede to",
                "accelerate",
                "accentuate",
                "accompany",
                "accomplish",
                "accorded",
                "accrue",
                "acquiesce",
                "acquire",
                "additional",
                "adjacent to",
                "adjustment",
                "admissible",
                "advantageous",
                "adversely impact",
                "advise",
                "aforementioned",
                "aggregate",
                "aircraft",
                "all of",
                "all things considered",
                "so to say",
                "that being said",
                "alleviate",
                "allocate",
                "along the lines of",
                "already existing",
                "alternatively",
                "amazing",
                "ameliorate",
                "anticipate",
                "apparent",
                "appreciable",
                "as a matter of fact",
                "as a means of",
                "as far as I\'m concerned",
                "as of yet",
                "as to",
                "as yet",
                "ascertain",
                "assistance",
                "at the present time",
                "at this time",
                "attain",
                "attributable to",
                "authorize",
                "because of the fact that",
                "belated",
                "benefit from",
                "bestow",
                "by means of",
                "by virtue of the fact that",
                "by virtue of",
                "cease",
                "close proximity",
                "commence",
                "comply with",
                "concerning",
                "consequently",
                "consolidate",
                "constitutes",
                "demonstrate",
                "depart",
                "designate",
                "discontinue",
                "due to the fact that",
                "each and every",
                "economical",
                "eliminate",
                "elucidate",
                "employ",
                "endeavor",
                "enumerate",
                "equitable",
                "equivalent",
                "evaluate",
                "evidenced",
                "exclusively",
                "expedite",
                "expend",
                "expiration",
                "facilitate",
                "factual evidence",
                "feasible",
                "finalize",
                "first and foremost",
                "for all intents and purposes",
                "it stands to reason",
                "for the most part",
                "for the purpose of",
                "forfeit",
                "formulate",
                "have a tendency to",
                "honest truth",
                "however",
                "if and when",
                "impacted",
                "implement",
                "in a manner of speaking",
                "in a timely manner",
                "in a very real sense",
                "in accordance with",
                "in addition",
                "in all likelihood",
                "in an effort to",
                "in between",
                "in excess of",
                "in lieu of",
                "in light of the fact that",
                "in many cases",
                "in my opinion",
                "in order to",
                "in regard to",
                "in some instances",
                "in terms of",
                "in the case of ",
                "in the event that",
                "in the final analysis",
                "in the nature of",
                "in the near future",
                "in the process of",
                "inception",
                "incumbent upon",
                "indicate",
                "indication",
                "initiate",
                "irregardless",
                "is applicable to",
                "is authorized to",
                "is responsible for",
                "it is essential",
                "it is",
                "it seems that",
                "it was",
                "magnitude",
                "maximum",
                "methodology",
                "minimize",
                "minimum",
                "modify",
                "monitor",
                "multiple",
                "necessitate",
                "nevertheless",
                "not certain",
                "not many",
                "not often",
                "not unless",
                "not unlike",
                "notwithstanding",
                "null and void",
                "numerous",
                "objective",
                "obligate",
                "obtain",
                "on the contrary",
                "on the other hand",
                "one particular",
                "optimum",
                "overall",
                "owing to the fact that",
                "participate",
                "particulars",
                "pass away",
                "pertaining to",
                "point in time",
                "portion",
                "possess",
                "preclude",
                "previously",
                "prior to",
                "prioritize",
                "procure",
                "proficiency",
                "provided that",
                "purchase",
                "put simply",
                "readily apparent",
                "refer back",
                "regarding",
                "relocate",
                "remainder",
                "remuneration",
                "requirement",
                "reside",
                "residence",
                "retain",
                "satisfy",
                "shall",
                "should you wish",
                "similar to",
                "solicit",
                "span across",
                "strategize",
                "subsequent",
                "substantial",
                "successfully complete",
                "sufficient",
                "terminate",
                "the month of",
                "the point I am trying to make",
                "therefore",
                "time period",
                "took advantage of",
                "transmit",
                "transpire",
                "type of",
                "until such time as",
                "utilization",
                "utilize",
                "validate",
                "various different",
                "what I mean to say is",
                "whether or not",
                "with respect to",
                "with the exception of",
                "witnessed"
            };

            passive_words = {
                "awoken",
                "been",
                "born",
                "beat",
                "become",
                "begun",
                "bent",
                "beset",
                "bet",
                "bid",
                "bidden",
                "bound",
                "bitten",
                "bled",
                "blown",
                "broken",
                "bred",
                "brought",
                "broadcast",
                "built",
                "burnt",
                "burst",
                "bought",
                "cast",
                "caught",
                "chosen",
                "clung",
                "come",
                "cost",
                "crept",
                "cut",
                "dealt",
                "dug",
                "dived",
                "done",
                "drawn",
                "dreamt",
                "driven",
                "drunk",
                "eaten",
                "fallen",
                "fed",
                "felt",
                "fought",
                "found",
                "fit",
                "fled",
                "flung",
                "flown",
                "forbidden",
                "forgotten",
                "foregone",
                "forgiven",
                "forsaken",
                "frozen",
                "gotten",
                "given",
                "gone",
                "ground",
                "grown",
                "hung",
                "heard",
                "hidden",
                "hit",
                "held",
                "hurt",
                "kept",
                "knelt",
                "knit",
                "known",
                "laid",
                "led",
                "leapt",
                "learnt",
                "left",
                "lent",
                "let",
                "lain",
                "lighted",
                "lost",
                "made",
                "meant",
                "met",
                "misspelt",
                "mistaken",
                "mown",
                "overcome",
                "overdone",
                "overtaken",
                "overthrown",
                "paid",
                "pled",
                "proven",
                "put",
                "quit",
                "read",
                "rid",
                "ridden",
                "rung",
                "risen",
                "run",
                "sawn",
                "said",
                "seen",
                "sought",
                "sold",
                "sent",
                "set",
                "sewn",
                "shaken",
                "shaven",
                "shorn",
                "shed",
                "shone",
                "shod",
                "shot",
                "shown",
                "shrunk",
                "shut",
                "sung",
                "sunk",
                "sat",
                "slept",
                "slain",
                "slid",
                "slung",
                "slit",
                "smitten",
                "sown",
                "spoken",
                "sped",
                "spent",
                "spilt",
                "spun",
                "spit",
                "split",
                "spread",
                "sprung",
                "stood",
                "stolen",
                "stuck",
                "stung",
                "stunk",
                "stridden",
                "struck",
                "strung",
                "striven",
                "sworn",
                "swept",
                "swollen",
                "swum",
                "swung",
                "taken",
                "taught",
                "torn",
                "told",
                "thought",
                "thrived",
                "thrown",
                "thrust",
                "trodden",
                "understood",
                "upheld",
                "upset",
                "woken",
                "worn",
                "woven",
                "wed",
                "wept",
                "wound",
                "won",
                "withheld",
                "withstood",
                "wrung",
                "written"
            };

            passive_future_words = {
                "help",
                "run",
                "clean",
                "win"
            };

            adverbs_words = {
                "absolutel",
                "accidentall",
                "additionall",
                "allegedl",
                "alternativel",
                "angril",
                "anxiousl",
                "approximatel",
                "awkwardl",
                "badl",
                "barel",
                "beautifull",
                "blindl",
                "boldl",
                "bravel",
                "brightl",
                "briskl",
                "bristl",
                "bubbl",
                "busil",
                "calml",
                "carefull",
                "carelessl",
                "cautiousl",
                "cheerfull",
                "clearl",
                "closel",
                "coldl",
                "completel",
                "consequentl",
                "correctl",
                "courageousl",
                "crinkl",
                "cruell",
                "crumbl",
                "cuddl",
                "currentl",
                "daringl",
                "deadl",
                "definitel",
                "deliberatel",
                "doubtfull",
                "dumbl",
                "eagerl",
                "earl",
                "easil",
                "elegantl",
                "enormousl",
                "enthusiasticall",
                "equall",
                "especiall",
                "eventuall",
                "exactl",
                "exceedingl",
                "exclusivel",
                "extremel",
                "fairl",
                "faithfull",
                "fatall",
                "fiercel",
                "finall",
                "fondl",
                "foolishl",
                "fortunatel",
                "frankl",
                "franticall",
                "generousl",
                "gentl",
                "giggl",
                "gladl",
                "gracefull",
                "greedil",
                "happil",
                "hardl",
                "hastil",
                "healthil",
                "heartil",
                "helpfull",
                "honestl",
                "hourl",
                "hungril",
                "hurriedl",
                "immediatel",
                "impatientl",
                "inadequatel",
                "ingeniousl",
                "innocentl",
                "inquisitivel",
                "interestingl",
                "irritabl",
                "jiggl",
                "joyousl",
                "justl",
                "kindl",
                "largel",
                "latel",
                "lazil",
                "likel",
                "literall",
                "lonel",
                "loosel",
                "loudl",
                "loudl",
                "luckil",
                "madl",
                "man",
                "mentall",
                "mildl",
                "mortall",
                "mostl",
                "mysteriousl",
                "neatl",
                "nervousl",
                "noisil",
                "normall",
                "obedientl",
                "occasionall",
                "onl",
                "openl",
                "painfull",
                "particularl",
                "patientl",
                "perfectl",
                "politel",
                "poorl",
                "powerfull",
                "presumabl",
                "previousl",
                "promptl",
                "punctuall",
                "quarterl",
                "quickl",
                "quietl",
                "rapidl",
                "rarel",
                "reall",
                "recentl",
                "recklessl",
                "regularl",
                "relativel",
                "reluctantl",
                "remarkabl",
                "repeatedl",
                "rightfull",
                "roughl",
                "rudel",
                "sadl",
                "safel",
                "selfishl",
                "sensibl",
                "seriousl",
                "sharpl",
                "shortl",
                "shyl",
                "significantl",
                "silentl",
                "simpl",
                "sleepil",
                "slowl",
                "smartl",
                "smell",
                "smoothl",
                "softl",
                "solemnl",
                "sparkl",
                "speedil",
                "stealthil",
                "sternl",
                "stupidl",
                "substantiall",
                "successfull",
                "suddenl",
                "surprisingl",
                "suspiciousl",
                "swiftl",
                "tenderl",
                "tensel",
                "thoughtfull",
                "tightl",
                "timel",
                "truthfull",
                "unexpectedl",
                "unfortunatel",
                "usuall",
                "ver",
                "victoriousl",
                "violentl",
                "vivaciousl",
                "warml",
                "waverl",
                "weakl",
                "wearil",
                "wildl",
                "wisel",
                "worldl",
                "wrinkl"
            };

            weak_words = {
                "just",
                "maybe",
                "stuff",
                "things"
            };
        }
    }
}