import PyPDF2
import os

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
            text = text.replace("\n","")
            text = " ".join(text.split(split_str)[1:])
        paragraphes = [paragraphe.replace("/n"," ") for paragraphe in text.split("./n ")]
        
        return " ".join(paragraphes)
    
    def process_dir(self, path_dir, split_str="Beoordeling door de Raad"):
        list_pdf = [name_file  for name_file in os.listdir(path_dir) if ".pdf" in name_file]
        
        textes = []
        for name_file in list_pdf:
            print(name_file)
            textes.append(self.process(path_dir+name_file, split_str))
            
        return list_pdf, textes
            
    