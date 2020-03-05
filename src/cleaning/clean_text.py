import spacy
from spacy.lang.nl import STOP_WORDS

from cleaning.abstract_cleaning import AbstractCleaning

class CleanTextNL(AbstractCleaning):
    def __init__(self):
        self.nlp = 
    
    def process(self, text):
        """Takes an input text in Duthc and cleans it up.
        We're going to remove punctuation, spaces and numbers.
        Then we will convert our words to lems and remove all STOP_WORDS
        
        Arguments:
            text {[String]} -- Text in Dutch to clean
            
        Return:
            String -- Text clean
        """
        nlp = spacy.load("nl_core_news_sm")

        lems = [tok.lemma_ for tok in nlp(text) if tok.pos_ not in ["PUNCT", "SPACE", "NUM"]]
        lems = [lem for lem in doc if lem not in STOP_WORDS]

        return " ".join(lems)
        
        