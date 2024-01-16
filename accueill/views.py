from datetime import date
from django.shortcuts import redirect, render
from django.core.mail import send_mail
from django.http import HttpResponse, JsonResponse
from login.models import Patient
from .models import Notification
from patient.models import Canaux
from directeur.models import Branche, Employe, Evaluation, Infirmier, Laboratoire, MedecinChef, Receptionniste, Reclamation
from quick_lab import settings
from django.core.mail import EmailMessage
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth import logout
from django.http import JsonResponse


from django.contrib.auth.decorators import login_required
# Create your views here.


def home(request):
    name = None
    fname = None
    lname = None
    if request.user.is_authenticated:
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
    context = {'name': name, 'fname':fname, 'lname': lname}

    if request.method == 'POST':
        
        email = request.POST['email']
        message = request.POST['message']
        message= f"Message: {message}\nEmail: {email}"
        subject = 'request  information'
        emetter_email="abdelmadjidkahoul5@gmail.com"

        email = EmailMessage(
             subject=subject,
             body=message,
             from_email=settings.EMAIL_HOST_USER,
             to=[emetter_email],
               )
        email.send()
        return redirect('home')
    return render(request,"accueill/home.html",context)


def history(request):
    name = None
    fname = None
    lname = None
    if request.user.is_authenticated:
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
    context = {'name': name, 'fname':fname, 'lname': lname}

    return render(request,"accueill/history.html",context)


def about_us(request):
    name = None
    fname = None
    lname = None
    if request.user.is_authenticated:
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
    context = {'name': name, 'fname':fname, 'lname': lname}

    return render(request,"accueill/about-us.html",context)


def lab_detaille(request,id):

    if request.method == 'POST':
        form_name = request.POST.get('form_name')
        print(form_name)
        if form_name == 'Complain':   
        
            Complain_object = request.POST['Complain_object']
            Complain_text = request.POST['Complain_text']
            
            
            patient_id = request.user.id
        
            branche_id = request.POST['branche_id']
            
            patient = Patient.objects.get(id=patient_id)
            branche = Branche.objects.get(id=branche_id)
            

            
            Reclamation.objects.create(patient=patient,branche=branche,reclamation_text=Complain_text,reclamation_object=Complain_object)
            
            return redirect('lab_detaille', id=branche_id)
        
        elif  form_name == 'message':
            
            
            if  Canaux.objects.filter(branch=id,pat=request.user.id) :
                canaus= Canaux.objects.get(branch=id,pat=request.user.id)
                return redirect('message_patient', id=canaus.id)
            else :
                branche = Branche.objects.get(id=id)
                patient = Patient.objects.get(id=request.user.id)
                newcanaux = Canaux.objects.create(branch=branche,pat=patient)
                newcanaux.save()
                return redirect('message_patient', id=newcanaux.id)
                
    
    
    name = None
    fname = None
    lname = None 
    if request.user.is_authenticated:
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
    branch= Branche.objects.get(id=id)
    lab = Laboratoire.objects.get(id=branch.labo.id)
    jour_heur_tarvail = branch.jour_heur_tarvail

    day_hours_list = []
    day_hours_pairs = jour_heur_tarvail.split('$')

    for pair in day_hours_pairs:
      try:
          day, start_time, end_time = pair.split('>')
          day_hours_list.append({'day': day, 'start_time': start_time, 'end_time': end_time})
      except ValueError:
        # Handle the case where the pair doesn't have the expected format
        # You can print an error message or take appropriate action
          print(f"Invalid format for pair: {pair}")

    context = {'name': name, 'fname': fname, 'lname': lname, "branch": branch, "laboratoire": lab, 'day_hours_list': day_hours_list}

    return render(request,"accueill/lab_detaille.html",context)






def laboratoire_list(request):
    if request.method == 'POST':
        
        patient_id = request.user.id
        print(patient_id)
        stars_number = request.POST['stars_number']
        
        branche_id = request.POST['branche_id']
        
        patient = Patient.objects.get(id=patient_id)
        branche = Branche.objects.get(id=branche_id)
        
        today = date.today()
        
        Evaluation.objects.create(patient=patient,barcnh=branche,nombre_etoiles=stars_number,date=today)
        
        return redirect('laboratoire-list')
    name = None
    fname = None
    lname = None
    
    if request.user.is_authenticated:
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        
        
    labos = {}    
    laboratoires = Laboratoire.objects.all()

    for laboratoire in laboratoires :
        branches = Branche.objects.filter(labo=laboratoire)
        for branche in branches :
            etoile1 = Evaluation.objects.filter(nombre_etoiles=1,barcnh= branche.id).count()
            etoile2 = Evaluation.objects.filter(nombre_etoiles=2,barcnh= branche.id).count()
            etoile3 = Evaluation.objects.filter(nombre_etoiles=3,barcnh= branche.id).count()
            etoile4 = Evaluation.objects.filter(nombre_etoiles=4,barcnh= branche.id).count()
            etoile5 = Evaluation.objects.filter(nombre_etoiles=5,barcnh= branche.id).count()
            
            
            labos.setdefault(branche, []).append({
            'laboratoire':laboratoire,
            'branche': branche,
            'etoiles': {
                1: etoile1,
                2: etoile2,
                3: etoile3,
                4: etoile4,
                5: etoile5
            }
        })
   
    print(labos)
    context = {'name': name, 'fname':fname, 'lname': lname,'labos':labos}
    

    return render(request,"accueill/laboratoire-list.html",context)


def privecy(request):
    
    return render(request,"accueill/privecy.html")


def term(request):
    return render(request,"accueill/term.html")





@login_required
def signout(request):
    logout(request)
    messages.success(request, 'You have successfully logged out.')
    return redirect('/')



@login_required
def book_appointment(request):
    # Your logic to handle the appointment booking
    return render(request, 'patiant/Book_Appointment.html')

def check_patient(request):
    if request.user.is_authenticated:
        return redirect('book_appointment')
    else:
        return redirect('login')
    
    
    
def notification_data(request):
    mockNotification = []
    
    notifications = Notification.objects.filter(is_read=False,id_prs=request.user.id)
   
    for notification in notifications:
        notification_pannel = {
            "createdBy": "Quicklab",
            "etat": notification.is_read,
            "createdOn": notification.date,
            "distination": notification.id_prs.id,
            "id": notification.id,
            "text": notification.contenu,
        }
        mockNotification.append(notification_pannel)
   
    if request.method == 'POST':
        id = request.POST.get('id')
        notification = Notification.objects.get(id=id)
        notification.is_read = True
        notification.save()
        return JsonResponse({'success': True})
    
    return JsonResponse(mockNotification, safe=False)



@login_required
def show_all_notification(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('notification_patient')
        elif hasattr(user, 'directeur'):
            return redirect('notification_directeur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('notification_receptioniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('notification_medecin')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('notification_infermieur')
      
      

@login_required
def account_all(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('account')
        elif hasattr(user, 'directeur'):
            return redirect('account_directeur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('account_receptioniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('account_medecin')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('account_infermieur')