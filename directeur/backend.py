from login.models import Personne
import random
import string
from .models import Employe, Receptionniste, MedecinChef, Infirmier

def generate_username():
    """Generate a random username"""
    # Get a list of all usernames in the database
    usernames = Personne.objects.values_list('nom_utilisateur', flat=True)
    
    # Generate a random username
    while True:
        username = ''.join(random.choices(string.ascii_lowercase, k=8))
        if username not in usernames:
            break
    
    return username

def generate_password():
    """Generate a random password"""
    # Generate a random password with 12 characters
    return ''.join(random.choices(string.ascii_letters + string.digits, k=12))

def get_employee_role(empid):
    try:
        employee = Employe.objects.get(id=empid)
    except Employe.DoesNotExist:
        return 'None1'
    
    receptionist = Receptionniste.objects.filter(id=employee).exists()
    head_physician = MedecinChef.objects.filter(id=employee).exists()
    nurse = Infirmier.objects.filter(id=employee).exists()
    
    if receptionist:
        return 'receptionist'
    elif head_physician:
        return 'the auditor'
    elif nurse:
        return 'nurse'
    else:
        return None
