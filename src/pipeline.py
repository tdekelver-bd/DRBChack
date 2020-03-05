
from load_data.pdf_load import PdfLoadData
from cleaning.clean_text_nl import CleanTextNL
from encoding.tfidf_encoding import TFIDFEncoding


load_data = PdfLoadData()
clean_text = CleanTextNL()

text = load_data.process("./data/input_pdf/RVVB.A.1819.0002.pdf")
text = clean_text.process(text)

encoder = TFIDFEncoding(text)

for sent in text:
    print(sent)
    print(encoder.process([sent]))