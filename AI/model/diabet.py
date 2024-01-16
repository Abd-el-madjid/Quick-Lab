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




def prediction_dibaset(input_array):
    columns_of_data = ['preg', 'gluco', 'bp', 'stinmm', 'insulin', 'mass', 'dpf', 'age']
    data = pd.DataFrame(input_array.reshape(1, -1), columns=columns_of_data)
    result_array = np.array(data)
    prediction = rf_random.predict_proba(result_array)

    # Get the best estimator
    best_rf = rf_random.best_estimator_
    
    # Get feature importances from the best estimator
    importances = best_rf.feature_importances_
    importances= (importances / importances.sum()) * 100
    # Print the prediction
    

    
    return columns_of_data, importances,prediction[0][1]*100

