from abc import ABC, abstractmethod 

class AbstractEncoding(ABC):
    @abstractmethod
    def __init__(self, data):
        """Inialisation of an encoding function for text.
        
        Arguments:
            data {[String]} -- Data used for encoding.
        """
        pass
        
    
    @abstractmethod
    def process(self, data):
        """Encodes data as a vector
        
        Arguments:
            data {[String]} -- [description]
            
        Return:
            [Vector] -- Vectorized data
        """
        pass