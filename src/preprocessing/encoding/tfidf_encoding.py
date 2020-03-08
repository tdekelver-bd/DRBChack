import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer

from preprocessing.encoding.abstract_encoding import AbstractEncoding

class TFIDFEncoding(AbstractEncoding):
    def __init__(self, data):
        """Inialisation of the TFIDF.
        
        Arguments:
            data {[String]} -- Data used for conf the TFIDF.
        """
        self.vectorizer = TfidfVectorizer()
        self.vectorizer.fit(data)
    
    def process(self, data):
        """Encodes data as a vector
        
        Arguments:
            data {[String]} -- [description]
            
        Return:
            [Vector] -- Vectorized data
        """
        return [d.toarray() for d in self.vectorizer.transform(data)]
        
    def get_feature_names(self):
        """Returns the list of words used by the tfidf
        
        Returns:
            [String] -- list of words used by the tfidf
        """
        return self.vectorizer.get_feature_names()

        