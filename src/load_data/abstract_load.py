from abc import ABC, abstractmethod 

class AbstractLoadData(ABC):
        
    @abstractmethod
    def process(self, path_data):
        """Extract the text from the file at the path_data location.
        
        Arguments:
            path_data {String} -- Path of the file to process
        
        Returns:
            {String} -- Text extract
        """
        pass