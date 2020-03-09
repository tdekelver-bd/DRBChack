
from load_data.pdf_load import PdfLoadData
from preprocessing.preprocessing import Preprocessing
from model.svm_model import SVMModel

load_data = PdfLoadData()

text = load_data.process("./data/input_pdf/RVVB.A.0010.0025.pdf")
text2 = load_data.process("./data/input_pdf/RVVB.A.1819.1356.pdf")

import pandas as pd
text_names = pd.read_csv("./data/arrest_names_new.csv")
names_tags= pd.read_csv("./data/arrests_trefwoorden.csv", encoding='latin1')
text_tags= pd.merge(text_names, names_tags, how="left",left_on='EVR_nr', right_on='Nr_Arrest')[['A_names', 'EVR_nr','Trefwoorden']]


list_tags = ["TAG1", "TAG2", "TAG3"]
preprocessing = Preprocessing([text, text2], list_tags)

data_process =  preprocessing.process([text, text2], [["TAG1", "TAG2"],["TAG3"]])

model = SVMModel(list_tags)

model.train(data_process)


