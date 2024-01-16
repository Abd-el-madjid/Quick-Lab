
from login.models import Employe, Infirmier

from .models import RendezVous, TravailInfermier

def assign_workload(rdv_id, branch_id):
    # Get the appointment
    appointment = RendezVous.objects.get(id=rdv_id)

    # Find all travail objects for the given date
    travaux = TravailInfermier.objects.filter(id_rdv__date=appointment.date)

    # Find employes working in the same branch
    employes = Employe.objects.filter(id_branche_id=branch_id)

    # Get the infirmiers associated with the employes
    infirmiers = Infirmier.objects.filter(id__in=employes.values('id'))

    # Count the workload for each infirmier
    workload_counts = {}
    for infirmier in infirmiers:
        workload_counts[infirmier.id.id] = travaux.filter(id_infermier=infirmier).count()

    # Sort infirmiers by workload in ascending order
    sorted_infirmiers = sorted(workload_counts, key=lambda k: workload_counts[k])

    # Assign the workload to the infirmier with the least work or the only infirmier
    if len(infirmiers) == 1:
        infirmier = infirmiers.first()
    else:
        # Check if there are infirmiers with workload
        if sorted_infirmiers:
            infirmier_id = sorted_infirmiers[0]
            infirmier = infirmiers.get(id=infirmier_id)
        else:
            # If no infirmiers have workload, assign to the first infirmier
            infirmier = infirmiers.first()

    # Create the TravailInfermier object with the assigned infirmier
    TravailInfermier.objects.create(
        id_infermier=infirmier,
        id_rdv=appointment,
        is_terminer=False
    )


def recomondation_diabet(prediction):
    if prediction < 25:
        recommendation = "1. Monitor carbohydrate intake: Pay attention to the quantity and quality of carbohydrates consumed to prevent significant spikes in blood sugar levels.\n" \
                         "2. Engage in regular physical activity: Incorporate moderate exercise into your routine to help improve insulin sensitivity and glucose control.\n" \
                         "3. Stay consistent with medication: Take prescribed medications as directed by your healthcare professional to help manage your blood sugar effectively.\n" \
                         "4. Maintain a healthy weight: Aim for a healthy weight range to improve insulin sensitivity and reduce the risk of complications associated with diabetes.\n" \
                         "5. Regularly check blood pressure and cholesterol levels: High blood pressure and cholesterol can increase the risk of cardiovascular complications, so it's essential to monitor and manage these levels."
    elif prediction >= 25 and prediction < 50:
        recommendation = "1. Follow a balanced meal plan: Consume a well-rounded diet consisting of complex carbohydrates, lean proteins, healthy fats, and plenty of fruits and vegetables.\n" \
                         "2. Practice portion control: Be mindful of portion sizes to help regulate your carbohydrate intake and maintain stable blood sugar levels.\n" \
                         "3. Establish a consistent meal schedule: Eating meals at regular intervals can help maintain steady blood sugar levels throughout the day.\n" \
                         "4. Keep a food diary: Tracking your food intake and blood sugar levels can provide insights into how different foods affect your glucose control.\n" \
                         "5. Educate yourself about diabetes: Learn about the condition, its management, and potential complications to make informed decisions about your health."
    elif prediction >= 50 and prediction < 75:
        recommendation = "1. Work closely with a healthcare team: Collaborate with your healthcare professionals to develop an individualized diabetes management plan and address any concerns or questions you may have.\n" \
                         "2. Regularly monitor blood sugar levels: Frequent monitoring allows for better understanding and control of your glucose levels.\n" \
                         "3. Prioritize stress management: Implement stress reduction techniques such as mindfulness, meditation, or engaging in enjoyable activities to minimize the impact of stress on blood sugar levels.\n" \
                         "4. Join a support group: Connect with others who have diabetes to share experiences, knowledge, and emotional support.\n" \
                         "5. Schedule comprehensive eye and foot exams: Regular check-ups can help detect and address potential complications related to diabetes, such as eye and foot problems."
    elif prediction >= 75:
        recommendation = "1. Work closely with a healthcare team: Collaborate with your healthcare professionals to develop an individualized diabetes management plan and address any concerns or questions you may have.\n" \
                         "2. Regularly monitor blood sugar levels: Frequent monitoring allows for better understanding and control of your glucose levels.\n" \
                         "3. Prioritize stress management: Implement stress reduction techniques such as mindfulness, meditation, or engaging in enjoyable activities to minimize the impact of stress on blood sugar levels.\n" \
                         "4. Join a support group: Connect with others who have diabetes to share experiences, knowledge, and emotional support.\n" \
                         "5. Schedule comprehensive eye and foot exams: Regular check-ups can help detect and address potential complications related to diabetes, such as eye and foot problems.\n" \
                         "6. Maintain a heart-healthy lifestyle: Adopt habits that promote cardiovascular health, such as consuming a balanced diet low in saturated and trans fats, exercising regularly, and avoiding smoking."
    else:
        recommendation = "Invalid prediction. Please provide a valid prediction percentage."
    return recommendation

def prediction_diabet(percentage, factors):
    if percentage>= 50:
        message = f"Based on the test result that the patient underwent, it has been determined that they are {percentage:.2f}% likely to have diabetes. The test used various factors, such as {', '.join(factors)}, among others, to arrive at this conclusion. It is important to note that while the test is highly accurate, it is not infallible, and additional tests and consultations with medical professionals may be required to confirm the diagnosis. Additionally, it is crucial for the patient to receive proper treatment and make necessary lifestyle changes to manage the condition and prevent further complications. With proper care and management, individuals with diabetes can lead healthy and fulfilling lives."
    else:
        message = f"Based on the test results, it appears that the patient {100-percentage:.2f}% does not have diabetes. It is important to note that these predictions are based on statistical models and should not be taken as a definitive diagnosis. It is recommended that the patient consult with a healthcare professional for further evaluation and testing."

    return message

def recomondation_Anemia(prediction):
    if prediction < 25:
        recommendation = "1. Increase iron-rich foods: Consume foods such as lean meats, poultry, fish, leafy green vegetables, and fortified cereals that are high in iron.\n" \
                         "2. Include vitamin C-rich foods: Pair iron-rich foods with sources of vitamin C, such as citrus fruits or bell peppers, to enhance iron absorption.\n" \
                         "3. Consider iron supplementation: Talk to your healthcare professional about iron supplements if necessary, based on your specific needs and blood tests.\n" \
                         "4. Ensure adequate folate and vitamin B12 intake: Consume foods like legumes, fortified grains, and animal products to support red blood cell production.\n" \
                         "5. Consult with a healthcare professional: Discuss your symptoms and concerns with a healthcare provider to determine the underlying cause and appropriate treatment."
    elif prediction >= 25 and prediction < 50:
        recommendation = "1. Consume iron-rich foods: Include sources of iron such as lean meats, poultry, fish, legumes, and fortified cereals in your diet.\n" \
                         "2. Optimize vitamin C intake: Pair iron-rich foods with vitamin C sources to enhance iron absorption.\n" \
                         "3. Include foods rich in folate and vitamin B12: Consume foods like leafy green vegetables, fortified grains, and animal products to support red blood cell production.\n" \
                         "4. Limit intake of iron inhibitors: Avoid consuming foods high in phytates (found in some whole grains and legumes) and tannins (found in tea and coffee) that can hinder iron absorption.\n" \
                         "5. Consult with a healthcare professional: Seek guidance from a healthcare provider to monitor your condition and adjust your treatment plan as necessary."
    elif prediction >= 50 and prediction < 75:
        recommendation = "1. Ensure adequate iron intake: Include a variety of iron-rich foods such as lean meats, fish, legumes, dark leafy greens, and fortified cereals in your diet.\n" \
                         "2. Consume foods high in vitamin C: Pair iron-rich foods with sources of vitamin C, such as citrus fruits, berries, and bell peppers, to enhance iron absorption.\n" \
                         "3. Incorporate foods rich in folate and vitamin B12: Include sources like legumes, leafy green vegetables, fortified grains, and animal products in your meals.\n" \
                         "4. Consider cooking in cast-iron cookware: Cooking acidic foods in cast-iron pans can help increase dietary iron intake.\n" \
                         "5. Regularly monitor your blood levels: Stay in touch with your healthcare provider for periodic blood tests to assess your iron status and adjust treatment if needed."
    elif prediction >= 75:
        recommendation = "1. Seek medical evaluation: Consult with a healthcare professional to determine the underlying cause of anemia and develop a comprehensive treatment plan.\n" \
                         "2. Follow prescribed treatments: Adhere to the recommended treatment protocol, which may include iron supplements, vitamin supplementation, or other therapies.\n" \
                         "3. Optimize nutrition: Ensure a well-balanced diet with a variety of iron-rich foods, vitamin C sources, and foods high in folate and vitamin B12.\n" \
                         "4. Consider supportive measures: Explore additional strategies like blood transfusions or intravenous iron therapy under medical supervision.\n" \
                         "5. Regularly monitor your condition: Stay in touch with your healthcare provider for follow-up visits and ongoing management of your anemia."
    else:
        recommendation = "Invalid prediction. Please provide a valid prediction percentage."
    return recommendation


def prediction_Anemia(percentage, factors):
    if percentage >= 50:
        message = f"Based on the test result that the patient underwent, it has been determined that they are {percentage:.2f}% likely to have anemia. The test used various factors, such as {', '.join(factors)}, among others, to arrive at this conclusion. It is important to note that while the test is highly accurate, it is not infallible, and additional tests and consultations with medical professionals may be required to confirm the diagnosis. Treatment and management of anemia may involve dietary changes, iron supplementation, and addressing the underlying causes. Regular follow-ups with healthcare providers are recommended for proper monitoring and care."
    else:
        message = f"Based on the test results, it appears that the patient {100-percentage:.2f}% does not have anemia. It is important to note that these predictions are based on statistical models and should not be taken as a definitive diagnosis. It is recommended that the patient consult with a healthcare professional for further evaluation and testing."

    return message

def recomondation_Heart(prediction):
    if prediction < 25:
        recommendation = "1. Adopt a heart-healthy diet: Consume a diet rich in fruits, vegetables, whole grains, lean proteins, and healthy fats.\n" \
                         "2. Engage in regular physical activity: Aim for at least 150 minutes of moderate-intensity aerobic exercise or 75 minutes of vigorous-intensity aerobic exercise each week.\n" \
                         "3. Maintain a healthy weight: Achieve and maintain a healthy weight through a combination of a balanced diet and regular exercise.\n" \
                         "4. Avoid smoking and tobacco use: If you smoke, seek support to quit, and avoid exposure to secondhand smoke.\n" \
                         "5. Monitor blood pressure and cholesterol levels: Regularly check and manage your blood pressure and cholesterol levels to reduce the risk of heart disease."
    elif prediction >= 25 and prediction < 50:
        recommendation = "1. Continue following a heart-healthy diet: Maintain a balanced diet that includes fruits, vegetables, whole grains, lean proteins, and healthy fats.\n" \
                         "2. Increase physical activity: Gradually increase your exercise intensity and duration to further improve cardiovascular fitness.\n" \
                         "3. Manage stress: Implement stress-reducing techniques like deep breathing, meditation, or engaging in hobbies and activities you enjoy.\n" \
                         "4. Maintain a healthy weight: Monitor your weight and make necessary adjustments to support heart health.\n" \
                         "5. Get regular health check-ups: Schedule routine check-ups to monitor your heart health and discuss any concerns with your healthcare provider."
    elif prediction >= 50 and prediction < 75:
        recommendation = "1. Follow a heart-healthy diet: Continue to prioritize a diet rich in fruits, vegetables, whole grains, lean proteins, and healthy fats.\n" \
                         "2. Engage in regular aerobic exercise: Aim for at least 150 minutes of moderate-intensity or 75 minutes of vigorous-intensity aerobic exercise each week.\n" \
                         "3. Control blood pressure and cholesterol levels: Manage and control high blood pressure and cholesterol through lifestyle modifications and medications if necessary.\n" \
                         "4. Limit sodium and processed foods: Reduce your intake of sodium, processed foods, and added sugars to support heart health.\n" \
                         "5. Quit smoking and limit alcohol: If you smoke, seek support to quit, and limit alcohol consumption to moderate levels or avoid it altogether."
    elif prediction >= 75:
        recommendation = "1. Seek immediate medical attention: If you haven't already, consult with a healthcare professional specializing in cardiology for a comprehensive evaluation and personalized treatment plan.\n" \
                         "2. Strictly follow medical recommendations: Comply with prescribed medications, lifestyle modifications, and interventions to manage and treat your heart condition.\n" \
                         "3. Engage in cardiac rehabilitation: If recommended by your healthcare provider, participate in a cardiac rehabilitation program to optimize your recovery and heart health.\n" \
                         "4. Maintain a heart-healthy lifestyle: Continue following a heart-healthy diet, engaging in regular exercise, managing stress, and avoiding tobacco and excessive alcohol use.\n" \
                         "5. Regularly monitor your heart health: Stay under the care of your healthcare provider for routine check-ups, cardiac tests, and ongoing management of your heart condition."
    else:
        recommendation = "Invalid prediction. Please provide a valid prediction percentage."
    return recommendation

def prediction_Heart(prediction, factors):
    if prediction >= 50:
        message = f"Based on the test result that the patient underwent, it has been determined that they are {prediction:.2f}% likely to have a heart condition. The test used various factors, such as {', '.join(factors)}, among others, to arrive at this conclusion. It is important to note that while the test is highly accurate, it is not infallible, and additional tests and consultations with medical professionals may be required to confirm the diagnosis. Treatment and management of heart conditions may involve medication, lifestyle changes, and regular monitoring. It is recommended to consult with a healthcare professional for further evaluation and guidance."
    else:
        message = f"Based on the test results, it appears that the patient {100-prediction:.2f}% does not have a heart condition. However, these predictions are based on statistical models and should not be taken as a definitive diagnosis. It is recommended that the patient consult with a healthcare professional for further evaluation and testing."

    return message


def recomondation_Liver(prediction):
    if prediction < 25:
        recommendation = "1. Limit alcohol consumption: Minimize or avoid alcohol as excessive alcohol intake can lead to liver damage.\n" \
                         "2. Maintain a healthy weight: Adopt a balanced diet and engage in regular physical activity to achieve and maintain a healthy weight.\n" \
                         "3. Avoid risky behaviors: Practice safe sex, avoid sharing needles, and take precautions to prevent exposure to hepatitis viruses.\n" \
                         "4. Vaccinate against hepatitis: Ensure you have received appropriate vaccinations for hepatitis A and B, depending on your risk factors.\n" \
                         "5. Consult with a healthcare professional: Regularly monitor your liver health through check-ups and seek guidance from a healthcare provider."
    elif prediction >= 25 and prediction < 50:
        recommendation = "1. Practice moderation with alcohol: If you consume alcohol, do so in moderation. For men, this typically means up to two drinks per day, and for women, up to one drink per day.\n" \
                         "2. Maintain a healthy weight: Aim for a healthy weight through a balanced diet and regular exercise.\n" \
                         "3. Eat a nutritious diet: Consume a diet rich in fruits, vegetables, whole grains, and lean proteins to support liver health.\n" \
                         "4. Limit processed and fatty foods: Reduce your intake of processed foods and foods high in unhealthy fats to support liver function.\n" \
                         "5. Stay hydrated: Drink an adequate amount of water daily to support overall liver health."
    elif prediction >= 50 and prediction < 75:
        recommendation = "1. Avoid alcohol: Completely abstain from alcohol consumption to protect your liver from further damage.\n" \
                         "2. Follow a liver-friendly diet: Consume a balanced diet with a focus on fruits, vegetables, whole grains, and lean proteins to support liver function.\n" \
                         "3. Stay hydrated: Drink sufficient water to support detoxification and overall liver health.\n" \
                         "4. Manage underlying conditions: Work closely with your healthcare provider to manage any underlying liver-related conditions, such as hepatitis or fatty liver disease.\n" \
                         "5. Regularly monitor liver function: Stay in touch with your healthcare provider for routine liver function tests and follow their recommendations."
    elif prediction >= 75:
        recommendation = "1. Seek medical evaluation and treatment: Consult with a hepatologist or healthcare professional specializing in liver diseases for a comprehensive evaluation and personalized treatment plan.\n" \
                         "2. Strictly avoid alcohol and hepatotoxic substances: Completely abstain from alcohol and avoid substances that can further harm the liver.\n" \
                         "3. Follow a specialized diet: Work with a registered dietitian to develop a specific diet plan that supports liver health and addresses your condition.\n" \
                         "4. Comply with prescribed medications: Take medications as directed by your healthcare provider to manage liver-related conditions and support liver function.\n" \
                         "5. Regularly monitor liver health: Stay under the care of your healthcare provider for frequent liver function tests and ongoing management of your condition."
    else:
        recommendation = "Invalid prediction. Please provide a valid prediction percentage."
    return recommendation

def prediction_Liver(prediction, factors):
    if prediction >= 50:
        message = f"Based on the test result that the patient underwent, it has been determined that they are {prediction:.2f}% likely to have a liver condition. The test used various factors, such as {', '.join(factors)}, among others, to arrive at this conclusion. It is important to note that while the test is highly accurate, it is not infallible, and additional tests and consultations with medical professionals may be required to confirm the diagnosis. Treatment and management of liver conditions may involve medication, lifestyle changes, and regular monitoring. It is recommended to consult with a healthcare professional for further evaluation and guidance."
    else:
        message = f"Based on the test results, it appears that the patient {100-prediction:.2f}% does not have a liver condition. However, these predictions are based on statistical models and should not be taken as a definitive diagnosis. It is recommended that the patient consult with a healthcare professional for further evaluation and testing."

    return message