import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split , RandomizedSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.inspection import permutation_importance
from sklearn.metrics import accuracy_score
from sklearn.metrics import accuracy_score, classification_report
from sklearn.ensemble import RandomForestClassifier

file_path = os.path.join('AI', 'dataset', 'Anemia-Prediction.csv')
dataset = pd.read_csv(file_path)

# Normalize the numerical columns using StandardScaler
standardScaler = StandardScaler()
columns_to_scale = ['Age', 'RBC', 'PCV', 'MCV', 'MCH', 'MCHC', 'RDW', 'TLC', 'PLT/mm3', 'HGB']
dataset[columns_to_scale] = standardScaler.fit_transform(dataset[columns_to_scale])

y = dataset['TEST']
X = dataset.drop(['TEST'],axis=1)

# Split into train and test sets
X_train,X_test,y_train,y_test = train_test_split(X,y,test_size =0.2, random_state=42)

rf_param_grid = {
    'n_estimators' : range(1,100,10),
}
rf = RandomForestClassifier()
rf_random = RandomizedSearchCV(param_distributions=rf_param_grid,estimator = rf,scoring="accuracy",verbose=0,n_iter=10,cv=4)
rf_random.fit(X_train,y_train)
best_params =rf_random.best_params_
rf_random.fit(X_train,y_train)
rf_classifier = RandomForestClassifier(n_estimators=best_params['n_estimators'])
rf_classifier.fit(X_train, y_train)
def prediction_anemia(input_array):
    columns_of_data = ['Age', 'Sex', 'RBC', 'PCV', 'MCV', 'MCH', 'MCHC', 'RDW', 'TLC', 'PLT/mm3', 'HGB']
    
    input_df = pd.DataFrame(input_array.reshape(1, -1), columns=columns_of_data)
    input_df[columns_to_scale] = standardScaler.transform(input_df[columns_to_scale])

    result_array = np.array(input_df)
    prediction = rf_random.predict_proba(result_array)

    # Calculate percentage probabilities
    percentage_anemia = prediction[0][1] * 100  # Probability of class 1 (anemia)
       # Probability of class 0 (not anemia)
    # Get the best estimator
    best_rf = rf_random.best_estimator_
    
    # Get feature importances from the best estimator
    importances = best_rf.feature_importances_
    
    importances= (importances / importances.sum()) * 100
    # Print the prediction
    
    return columns_of_data, importances,percentage_anemia

