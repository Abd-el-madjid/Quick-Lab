import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, RandomizedSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.metrics import classification_report, confusion_matrix

file_path = os.path.join('AI', 'dataset', 'indian_liver_patient.csv')
dataset = pd.read_csv(file_path)


y = dataset['target']
X = dataset.drop(['target'],axis=1)
X_train,X_test,y_train,y_test = train_test_split(X,y,test_size =0.3, random_state=42)



# Scale features (required for certain models like KNN and SVM)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)


rf_param_grid = {
    'n_estimators' : range(1,100,10),
}
rf = RandomForestClassifier()
rf_random = RandomizedSearchCV(param_distributions=rf_param_grid,estimator = rf,scoring="accuracy",verbose=0,n_iter=10,cv=4)
rf_random.fit(X_train,y_train)
best_params =rf_random.best_params_


rf_random.fit(X_train,y_train)

input_data = np.array([17,0,0.9,0.3,202,22,19,7.4,4.1,1.2])  # single patient's readings
input_data = input_data.reshape(1, -1)  # Reshape the input data to a 2D array
    
prediction = rf_random.predict(input_data)


def prediction_liver(input_array):
    columns_of_data = ['Age', 'Gender', 'Total_Bilirubin', 'Direct_Bilirubin', 'Alkaline_Phosphotase',
                     'Alamine_Aminotransferase', 'Aspartate_Aminotransferase', 'Total_Protiens',
                     'Albumin', 'Albumin_and_Globulin_Ratio']
    result_array = np.array(input_array).reshape(1, -1)
    prediction = rf_random.predict_proba(result_array)

    # Get the best estimator
    best_rf = rf_random.best_estimator_
    
    # Get feature importances from the best estimator
    importances = best_rf.feature_importances_
    importances= (importances / importances.sum()) * 100
    return columns_of_data, importances, prediction[0][1]*100

