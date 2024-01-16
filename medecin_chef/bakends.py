


from AI.model.diabet import prediction_dibaset
from AI.model.anemia import prediction_anemia
from AI.model.liver import prediction_liver
from patient.bakends import prediction_Anemia, prediction_Liver, prediction_diabet
from AI.model.anemia_med import save_data_anemia
from AI.model.diabet_med import save_data_diabet
from AI.model.liver_med import save_data_liver


def prediction(analyse_name, value):
    if analyse_name == 'diabetes analysis':
        feature_names, importances ,percentage= prediction_dibaset(value)
        rapport  = prediction_diabet(percentage,feature_names)
        save_data_diabet(value)
    elif analyse_name == 'anemia analysis':
        feature_names, importances ,percentage= prediction_anemia(value)
        rapport  = prediction_Anemia(percentage,feature_names)
        save_data_anemia(value)
    elif analyse_name == 'liver analysis':
        feature_names, importances, percentage = prediction_liver(value)
        rapport  = prediction_Liver(percentage,feature_names)
        save_data_liver(value)

    return  feature_names, importances, percentage, rapport