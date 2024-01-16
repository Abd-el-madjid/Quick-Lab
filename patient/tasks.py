from django.core.mail import send_mail
from django.utils import timezone
from login.models import Personne
from .models import RendezVous
from quick_lab import settings
import schedule
import time

def send_email_for_tomorrow_rdv():
    
    tomorrow = timezone.now().date() + timezone.timedelta(days=1)
    tomorrow_rdv = RendezVous.objects.filter(date=tomorrow)
    print("i work")
    subject = 'Rendezvous Reminder'
    from_email = settings.EMAIL_HOST_USER
    
    for rdv in tomorrow_rdv:
        recipient = Personne.objects.get(id=rdv.id_patient.id.id).email
        message = f'You have a rendezvous tomorrow at {rdv.heur}.'
        send_mail(subject, message, from_email, [recipient])

# def job():
#     send_email_for_tomorrow_rdv()
#     print("Scheduled email task executed.")

# schedule.every().day.at("01:00").do(job)

# while True:
#     schedule.run_pending()
#     time.sleep(60)  # Wait for 60 seconds






