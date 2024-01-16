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
file_path = os.path.join('AI', 'dataset', 'pima-indians-diabetes.csv')
dataset = pd.read_csv(file_path)
dataset = dataset.rename(index=str, columns={"6":"preg"})
dataset = dataset.rename(index=str, columns={"148":"gluco"})
dataset = dataset.rename(index=str, columns={"72":"bp"})
dataset = dataset.rename(index=str, columns={"35":"stinmm"})
dataset = dataset.rename(index=str, columns={"0":"insulin"})
dataset = dataset.rename(index=str, columns={"33.6":"mass"})
dataset =dataset.rename(index=str, columns={"0.627":"dpf"})
dataset = dataset.rename(index=str, columns={"50":"age"})
dataset = dataset.rename(index=str, columns={"1":"target"})

y = dataset['target']
X = dataset.drop(['target'],axis=1)
X_train,X_test,y_train,y_test = train_test_split(X,y,test_size =0.2, random_state=42)

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



def save_data_diabet(input_data):
    columns_of_data = ['preg', 'gluco', 'bp', 'stinmm', 'insulin', 'mass', 'dpf', 'age']
    data = pd.DataFrame(np.array(input_data).reshape(1, -1), columns=columns_of_data)
    result_array = np.array(data)
    prediction = rf_random.predict(result_array)

    # Concatenate prediction with input_data
    input_data_with_prediction = np.concatenate((input_data, prediction), axis=0)

    # Create a DataFrame for the original input data and prediction result
    data_df = pd.DataFrame([input_data_with_prediction], columns=['preg', 'gluco', 'bp', 'stinmm', 'insulin', 'mass', 'dpf', 'age', 'target'])

    # Load the existing CSV file
    file_path_save = os.path.join('AI', 'dataset', 'diabet_test_to_save.csv')
    existing_data = pd.read_csv(file_path_save)

    # Concatenate the new data with the existing data
    updated_data = pd.concat([existing_data, data_df], ignore_index=True)

    # Save the updated data to the CSV file
    updated_data.to_csv(file_path_save, index=False)
