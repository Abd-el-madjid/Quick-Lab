from django.contrib.auth.backends import ModelBackend
from .models import Personne
from django.utils import timezone
import random
import string
import vonage

class PersonneBackend(ModelBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            # Retrieve the user model based on the provided username
            user = Personne.objects.get(nom_utilisateur=username)

            # Use the `check_password()` method to verify the password
            if user.check_password(password):
                user.last_login =  (timezone.now() + timezone.timedelta(hours=1))
                if user.two_factor_enabled:  # Check if two-factor authentication is enabled for the user
                    # Generate a random verification code and save it in the user's model
                    verification_code = generate_random_code()
                    user.two_factor_secret = verification_code
                    user.save()

                    # Send the verification code via SMS
                    if send_verification_code(user.num_telephone, verification_code):
                        return user
                    else:
                        return None
                else:
                    # Normal authentication without two-factor authentication
                    return user


        except Personne.DoesNotExist:
            return None
    
    def get_user(self, user_id):
        try:
            # Retrieve the user model based on the user_id
            return Personne.objects.get(pk=user_id)

        except Personne.DoesNotExist:
            return None





def generate_random_code(length=6):
    characters = string.digits  # You can customize the characters used in the verification code
    code = ''.join(random.choice(characters) for _ in range(length))
    return code

def send_verification_code(phone_number, verification_code):
    # Initialize the Vonage client with your API credentials
    client = vonage.Client(key="12fcda1b", secret="hd32jGVq1c0fYcXu")
    sms = vonage.Sms(client)

    # Send the verification code via SMS
    response = sms.send_message({
        "from": "QUICK LAB",
        "to": "213" +phone_number,
        "text": f"Your verification code is: {verification_code}",
    })
    if response["messages"][0]["status"] == "0":
        return True  # Message sent successfully
    else:
        client = vonage.Client(key="e9cef254", secret="FzKwS0pvrySmZFXb")
        sms = vonage.Sms(client)

        # Send the verification code via SMS
        response = sms.send_message({
            "from": "QUICK LAB",
            "to": "213" +phone_number,
            "text": f"Your verification code is: {verification_code}",
        })
        if response["messages"][0]["status"] == "0":
            return True  # Message sent successfully
        else:
            return True