
from load_data.pdf_load import PdfLoadData
from preprocessing.preprocessing import Preprocessing
from model.svm_model import SVMModel

load_data = PdfLoadData()

print("process")
textes = load_data.process_dir("./data/input_pdf/")
print("End Process")
list_tags = ["TAG1", "TAG2", "TAG3"]
preprocessing = Preprocessing(textes, list_tags)
data_process =  preprocessing.process(textes, [["TAG1", "TAG2"],["TAG3"]])
print("End Preprocessing")

model = SVMModel(list_tags)

model.train(data_process)

print(model.predict(data_process["feature"]))

