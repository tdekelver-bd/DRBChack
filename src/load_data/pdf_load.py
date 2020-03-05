import PyPDF2

from load_data.abstract_load import AbstractLoadData


class PdfLoadData(AbstractLoadData):
    
    def process(self, path_pdf, split_str="Beoordeling door de Raad"):
        """Extract the text from the pdf file at the path_data location.
        
        Arguments:
            path_pdf {String} -- Path of the pdf file to process
        
        Returns:
            {String} -- Text extract
        """
        with open(path_pdf ,"rb") as pdfFile:
            pdf = PyPDF2.PdfFileReader(pdfFile)
            text = "/n ".join([pdf.getPage(i).extractText() for i in range(pdf.numPages)])
            
        if split_str is not None:
            text = " ".join(text.split(split_str)[1:])
        paragraphes = [paragraphe.replace("\n"," ").replace("/n"," ") for paragraphe in text.split(".\n ")]
        
        return paragraphes