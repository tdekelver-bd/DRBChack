from sklearn import svm

from model.abstract_model import AbstractModel

class SVMModel(AbstractModel):
    
    def __init__(self, list_tag):
        """Initializes the different models 
        Arguments:
            list_tag {[String]} -- list of the existant tag
        """
        self.list_tag = list_tag
        self.model_by_tag = {}
        for tag in list_tag:
            self.model_by_tag[tag] = svm.SVC()
            
        
    
    def train(self, data):
        """Trains the different models using the data on the different TAGs.
        
        Arguments:
            data {{ 
                "feature" : [[],[]],
                "TAG1" : [],
                "TAG2" : [], ...
                }} -- Data used for training
        """
        for tag in self.list_tag:
            self.model_by_tag[tag].fit[data["feature"], data[tag]]
    
    
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
        result = {}
        for tag in self.list_tag:
            result[tag] = self.model_by_tag[tag].predict()
            
        return result
    