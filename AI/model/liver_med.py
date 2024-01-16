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

def save_data_liver(input_data):
    columns_of_data = ['Age', 'Gender', 'Total_Bilirubin', 'Direct_Bilirubin', 'Alkaline_Phosphotase',
                     'Alamine_Aminotransferase', 'Aspartate_Aminotransferase', 'Total_Protiens',
                     'Albumin', 'Albumin_and_Globulin_Ratio']
    data = pd.DataFrame(np.array(input_data).reshape(1, -1), columns=columns_of_data)
    result_array = np.array(data)
    prediction = rf_random.predict(result_array)

    # Concatenate prediction with input_data
    input_data_with_prediction = np.concatenate((input_data, prediction), axis=0)

    # Create a DataFrame for the original input data and prediction result
    data_df = pd.DataFrame([input_data_with_prediction], columns=['Age', 'Gender', 'Total_Bilirubin', 'Direct_Bilirubin', 'Alkaline_Phosphotase',
                     'Alamine_Aminotransferase', 'Aspartate_Aminotransferase', 'Total_Protiens',
                     'Albumin', 'Albumin_and_Globulin_Ratio','target'])

    # Load the existing CSV file
    file_path_save = os.path.join('AI', 'dataset', 'liver_test_to_save.csv')
    existing_data = pd.read_csv(file_path_save)

    # Concatenate the new data with the existing data
    updated_data = pd.concat([existing_data, data_df], ignore_index=True)

    # Save the updated data to the CSV file
    updated_data.to_csv(file_path_save, index=False)
