
from load_data.pdf_load import PdfLoadData
from preprocessing.preprocessing import Preprocessing
from model.svm_model import SVMModel

load_data = PdfLoadData()

text = load_data.process("./data/input_pdf/RVVB.A.1819.0002.pdf")
text2 = load_data.process("./data/input_pdf/RVVB.A.1819.0002.pdf")

list_tags = ["TAG1", "TAG2", "TAG3"]
preprocessing = Preprocessing([text, text2], list_tags)

data_process =  preprocessing.process([text, text2], [["TAG1", "TAG2"],["TAG3"]])

model = SVMModel(list_tags)

model.train(data_process)