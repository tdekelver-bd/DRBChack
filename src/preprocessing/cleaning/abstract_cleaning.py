from abc import ABC, abstractmethod 

class AbstractCleaning(ABC):
    
    @abstractmethod
    def process(self, text):
        """Takes an input text and cleans it up.
        
        Arguments:
            text {[String]} -- Text to clean
            
        Return:
            String -- Text clean
        """
        pass
        