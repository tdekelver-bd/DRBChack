import spacy
from spacy.lang.nl import STOP_WORDS

from preprocessing.cleaning.abstract_cleaning import AbstractCleaning

class CleanTextNL(AbstractCleaning):
    def __init__(self):
        self.nlp = spacy.load("nl_core_news_sm")
    
    def process(self, text):
        """Takes an input text in Duthc and cleans it up.
        We're going to remove punctuation, spaces and numbers.
        Then we will convert our words to lems and remove all STOP_WORDS
        
        Arguments:
            text {[String]} -- Text in Dutch to clean
            
        Return:
            String -- Text clean
        """
        
        text_clean = []
        for sent in text:
            lems = [tok.lemma_ for tok in self.nlp(sent) if tok.pos_ not in ["PUNCT", "SPACE", "NUM"]]
            lems = [lem for lem in lems if lem not in STOP_WORDS]
            text_clean.append(" ".join(lems))
        return text_clean
        
        