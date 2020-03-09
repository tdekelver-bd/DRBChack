import PyPDF2
import os
import pandas as pd
import csv

from load_data.abstract_load import AbstractLoadData


class PdfLoadData(AbstractLoadData):
    def __init__(self, path_file_tag, path_file_name):
        df_tag = load_csv_unicode(path_file_tag)
        df_name_file = pd.read_csv(path_file_name)
        
        print(df_name_file.head())
        print(df_tag.head())

        self.df_tag_file = pd.merge(df_name_file, df_tag, left_on='EVR_nr', right_on='nr_arrests')
        
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
        """[summary]
        
        Arguments:
            path_dir {[String]} -- Dir to load
        
        
        Returns:
            [tags], [texte] -- Tags by text and text 
        """
        list_pdf = [name_file  for name_file in os.listdir(path_dir) if ".pdf" in name_file]
        
        textes = []
        tags = []
        for name_file in list_pdf:
            textes.append(self.process(path_dir+name_file, split_str))
            tags.append(list(self.df_tag_file[self.df_tag_file["A_names"]==name_file]["tags"]))
        return tags, textes
            
    
def load_csv_unicode(path_csv):
    with open(path_csv, "r") as f:
        nr_arrests = []
        names = []
        tags = []
        lines = csv.reader(f, delimiter = ',', quotechar = '|')
        for line in lines:
            nr_arrests.append(line[0])
            names.append(line[1])
            tags.append(line[2])
        df_at = pd.DataFrame()
        df_at["nr_arrests"] = [val.replace('"','') for val in nr_arrests[1:]]
        df_at["names"] =  [val.replace('"','') for val in names[1:]]
        df_at["tags"] =  [val.replace('"','') for val in tags[1:]]
        df_at["year"] =  df_at["nr_arrests"].apply(lambda val : val.split("/")[0]) 
    return df_at