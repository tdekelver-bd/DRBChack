from flask import Flask, request, jsonify

from load_data.pdf_load import PdfLoadData
from cleaning.clean_text_nl import CleanTextNL
from encoding.tfidf_encoding import TFIDFEncoding

load_data = PdfLoadData()
clean_text = CleanTextNL()

text = load_data.process("./data/input_pdf/RVVB.A.1819.0002.pdf")
text = clean_text.process(text)

encoder = TFIDFEncoding(text)

app = Flask(__name__)

@app.route('/')
def home():
    return 'Hello, I m running'


@app.route('/predict', methods=['POST'])
def predict():
    file = request.files.get('file')
    file.save("input.pdf")

    text = load_data.process("input.pdf")
    text = clean_text.process(text)
    output = encoder.process(text)
    
    return {"output": str(output)}




if __name__ == '__main__':
    app.run(port=5010)
