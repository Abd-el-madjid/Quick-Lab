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
from sklearn.inspection import permutation_importance
file_path = os.path.join('AI', 'dataset', 'heart.csv')
dataset = pd.read_csv(file_path)

# One-hot encode the categorical columns
dataset = pd.get_dummies(dataset, columns=['sex', 'cp', 'fbs', 'restecg', 'exang', 'slope', 'ca', 'thal'])

# Normalize the numerical columns using StandardScaler
standardScaler = StandardScaler()
columns_to_scale = ['age', 'trestbps', 'chol', 'thalach', 'oldpeak']

y = dataset['target']
X = dataset.drop(['target'],axis=1)
X_train,X_test,y_train,y_test = train_test_split(X,y,test_size =0.2, random_state=42)

svc_scores = []
kernels = ['linear', 'poly', 'rbf', 'sigmoid']
for kernel in kernels:
    svc_scores_c = []
    for ch in range(1,11):
        if kernel == 'poly':
            svc_scores_poly = []
            for d in range(3, 10):
                svc_classifier = SVC(kernel=kernel, C=ch, degree=d)
                svc_classifier.fit(X_train, y_train)
                svc_scores_poly.append(svc_classifier.score(X_test, y_test))
            best_degree = np.argmax(svc_scores_poly) + 3
            svc_scores_c.append(svc_scores_poly[best_degree-3])
        else:
            svc_classifier = SVC(kernel=kernel, C=ch)
            svc_classifier.fit(X_train, y_train)
            svc_scores_c.append(svc_classifier.score(X_test, y_test))
    best_c = np.argmax(svc_scores_c) + 1
    svc_scores.append(svc_scores_c[best_c-1])

best_kernel = kernels[np.argmax(svc_scores)]

svc_classifier = SVC(kernel ='rbf' , C=1, probability=True)  # Add probability=True
svc_classifier.fit(X_train , y_train)
def heart_prediction(input):
    # Create a DataFrame with the original feature names
    input_df = pd.DataFrame([input], columns=['age', 'sex', 'cp', 'trestbps', 'chol', 'fbs', 'restecg', 'thalach', 'exang', 'oldpeak', 'slope', 'ca', 'thal'])

    # Use the same preprocessing steps as the training data
    input_df = pd.get_dummies(input_df, columns=['sex', 'cp', 'fbs', 'restecg', 'exang', 'slope', 'ca', 'thal'])

    # Ensure the input has the same columns as the training set
    missing_cols = set(X_train.columns) - set(input_df.columns)
    for c in missing_cols:
        input_df[c] = 0
    input_df = input_df[X_train.columns]

    # Use the model to make a prediction
    prediction = svc_classifier.predict_proba(input_df)

    # Calculate feature importance using permutation importance
    result = permutation_importance(svc_classifier, X_test, y_test, n_repeats=10, random_state=42)

    # Get the feature importances and feature names
    feature_importance = result.importances_mean
    feature_names = X_train.columns

    # Create a dictionary for feature importances
    feature_importance_dict = dict(zip(feature_names, feature_importance))

    # List of original features
    original_features = ['age', 'sex', 'cp', 'trestbps', 'chol', 'fbs', 'restecg', 'thalach', 'exang', 'oldpeak', 'slope', 'ca', 'thal']

    # Create a dictionary for original feature importances
    original_importances = {feature: 0 for feature in original_features}

    # Sum the importances of dummy variables and assign to the original variable
    for feature, importance in feature_importance_dict.items():
        for original_feature in original_features:
            if original_feature in feature:
                original_importances[original_feature] += importance

    # Separate feature names and importances into two lists
    feature_names_list = list(original_importances.keys())
    feature_importances_list = list(original_importances.values())

    # Return the prediction, feature names list and feature importances list
    return prediction[0][1]*100, feature_names_list, feature_importances_list
