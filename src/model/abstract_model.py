from abc import ABC, abstractmethod 

class AbstractModel(ABC):
    @abstractmethod
    def __init__(self, list_tag):
        """Initializes the different models 
        Arguments:
            list_tag {[String]} -- list of the existant tag
        """
        pass
        
    @abstractmethod
    def train(self, data):
        """Trains the different models using the data on the different TAGs.
        
        Arguments:
            data {{ 
                "feature" : [[],[]],
                "TAG1" : [],
                "TAG2" : [], ...
                }} -- Data used for training
        """
        pass
    
    @abstractmethod
    def predict(self, texts):
        """Predicts for each of these texts the associated set of TAGs
        
        Arguments:
            data {[Vec]} -- Encoded texts  used for prediction
            
        Returns:
            {Dict(vec)} -- dictionaries of predictions by tag 
            Exple : {
                        TAG1:[1, 0],
                        TAG2:[0, 1],
                    } = Text1 is TAG1 and text2 is TAG2
        """
        pass
    