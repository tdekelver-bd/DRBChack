import numpy as np

def evaluate(labels, predicts):
    tot = len(predicts)
    tp = get_tp(np.copy(labels), np.copy(predicts))
    fp = get_fp(np.copy(labels), np.copy(predicts))
    tn = get_tn(np.copy(labels), np.copy(predicts))
    fn = get_fn(np.copy(labels), np.copy(predicts))
    
    if((tp + fp) != 0):
        precision = tp / (tp + fp)
    else:
        if(tot == 0):
            precision = 1
        else: precision = 0

    if((tp + fn) != 0):
        recall = tp / (tp + fn)
    else: recall = 0
    
    if (int(tot) == 0 and int(precision) == 1):
        f_score = 1
        
    elif((precision + recall) != 0):
        f_score = 2 * (precision * recall) / (precision + recall)
        
    else: 
        f_score = 0
    
    return {'textcat_p': precision, 'textcat_r': recall, 'textcat_f': f_score}
    
def get_tp(labs, preds):
    return np.sum(labs * preds)

def get_fp(labs, preds):
    labs[labs == 0] = -1
    labs[labs == 1] = 0
    
    return - np.sum(labs * preds)

def get_tn(labs, preds):
    labs[labs == 0] = -1
    labs[labs == 1] = 0
    
    preds[preds == 0] = -1
    preds[preds == 1] = 0

    return np.sum(labs * preds)
    
def get_fn(labs, preds):
    preds[preds == 0] = -1
    preds[preds == 1] = 0
    
    return - np.sum(labs * preds)