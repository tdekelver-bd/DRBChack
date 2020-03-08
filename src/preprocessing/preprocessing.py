import numpy as np

from preprocessing.cleaning.clean_text_nl import CleanTextNL
from preprocessing.encoding.tfidf_encoding import TFIDFEncoding


class Preprocessing():
    def __init__(self, texts, list_tag):
        self.clean_text = CleanTextNL()
        all_text = []
        for text in texts:
            all_text += self.clean_text.process(text)

        self.encoder = TFIDFEncoding(all_text)
        self.list_tag = list_tag
        
    
    def process(self, texts, tags_by_text):
        """Preprocesses the data so that it complies with the format entered by the models.
        
        Arguments:
            texts {String} -- Process Texts
            tags_by_text {[String]} -- Lists of tags by text [["TAG1","TAG3"], ["TAG3"]]
            
        Returns:
            {
                "feature" : Encoded text [[Float], [Float]]
                "TAG1" : tag present or not [1, 0, ...],
                "TAG2" : ...
            }
        """
        texts = [self.clean_text.process(text) for text in texts]
        encoded_texts = [self.encoder.process(text) for text in texts]
        encoded_tags = [self.encode_tag(tags) for tags in tags_by_text]

        #we are going to treat each paragraph of the text as an independent text 
        #   for that we are going to associate the tags of the text to it.
        encoded_texts_extend = []
        encoded_tags_extend = []
        for encoded_text, encoded_tag in zip(encoded_texts, encoded_tags):
            encoded_texts_extend += encoded_text
            encoded_tags_extend += [encoded_tag for t in encoded_text]
        
        transp_encoded_tags = np.transpose(encoded_tags_extend)
        
        result = {
            "feature": encoded_texts_extend
        }
        
        for idx, tag in enumerate(self.list_tag):
            result[tag] = transp_encoded_tags[idx]

        return result
            
        
    def encode_tag(self, tags):
        """Convert list tags to vec
        
        Arguments:
            tags {[String]} -- List tags
        
        Returns:
            Array(0,1) -- Vec with Tag presnet or not
        """
        result = np.zeros(len(self.list_tag))
        for tag in tags :
            result[self.list_tag.index(tag)] = 1
        return result
            
        