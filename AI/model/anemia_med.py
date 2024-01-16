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


# Split into features and target
y = dataset['TEST']
X = dataset.drop(['TEST'],axis=1)

# Split into train and test sets
X_train,X_test,y_train,y_test = train_test_split(X,y,test_size =0.2, random_state=42)


# Train a KNN model
knn_scores = []
for k in range(1,21):
    knn_classifier = KNeighborsClassifier(n_neighbors = k)
    knn_classifier.fit(X_train ,y_train)
    knn_scores.append(knn_classifier.score(X_test,y_test))

# Choose the best k
k = np.argmax(knn_scores) + 1

# Train the final model
knn_classifier = KNeighborsClassifier(n_neighbors = k)
knn_classifier.fit(X_train ,y_train)
# Test the model
y_pred = knn_classifier.predict(X_test)


def save_data_anemia(input_data):
    columns_to_scale = ['Age', 'RBC', 'PCV', 'MCV', 'MCH', 'MCHC', 'RDW', 'TLC', 'PLT/mm3', 'HGB']

    # Create a DataFrame with the original feature names
    input_df = pd.DataFrame([input_data], columns=['Age', 'Sex', 'RBC', 'PCV', 'MCV', 'MCH', 'MCHC', 'RDW', 'TLC', 'PLT/mm3', 'HGB'])

    # Scale the columns
    input_df[columns_to_scale] = standardScaler.transform(input_df[columns_to_scale])

    # Use the model to make a prediction
    prediction = knn_classifier.predict(input_df)

    # Create a DataFrame for the original input data and prediction result
    input_data_list = input_data.tolist()  # Convert input_data to a list
    input_data_list.append(prediction[0])
    data_df = pd.DataFrame([input_data_list], columns=['Age', 'Sex', 'RBC', 'PCV', 'MCV', 'MCH', 'MCHC', 'RDW', 'TLC', 'PLT/mm3', 'HGB', 'TEST'])

    # Load the existing CSV file
    file_path_save = os.path.join('AI', 'dataset', 'anemia_test_to_save.csv')
    existing_data = pd.read_csv(file_path_save)

    # Concatenate the new data with the existing data
    updated_data = pd.concat([existing_data, data_df], ignore_index=True)

    # Save the updated data to the CSV file
    updated_data.to_csv(file_path_save, index=False)
