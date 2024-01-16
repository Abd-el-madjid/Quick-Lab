from decimal import Decimal
import json
from django.contrib.auth import authenticate, login, logout
from django.shortcuts import redirect, render
from datetime import datetime
from django.db.models import Max
from django.core.mail import send_mail
from quick_lab import settings
from django.db import connection
from django.core.mail import EmailMessage

from admin.backends import AdminBackend
from directeur.models import Branche, Employe, Infirmier, Laboratoire,Directeur, MedecinChef, Receptionniste
from directeur.backend import generate_password, generate_username
from login.models import Patient, Personne
from patient.models import TravailInfermier
from .models import Abonnement
from django.utils.http import urlsafe_base64_encode
from django.contrib.auth.tokens import default_token_generator
from django.utils.encoding import force_bytes, force_str
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.contrib.auth.decorators import login_required

def admin_login(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        
        admin_backend = AdminBackend()  # Create an instance of the AdminBackend
        admin = admin_backend.authenticate(request, username=username, password=password)  # Call authenticate on the instance
        
        if admin is not None:
            login(request, admin, backend='admin.backends.AdminBackend')
            return redirect('lab_management')
        else:
            error_message = 'Invalid username or password'
            return render(request, 'admin/login.html', {'error_message': error_message})
    
    return render(request, 'admin/login.html')




def lab_management(request):
    with connection.cursor() as cursor:
        cursor.callproc("get_lab", [True])

        columns = [column[0] for column in cursor.description]
        lab = [dict(zip(columns, row)) for row in cursor.fetchall()]
    with connection.cursor() as cursor:
        cursor.callproc("get_lab", [False])

        columns = [column[0] for column in cursor.description]
        lab_block = [dict(zip(columns, row)) for row in cursor.fetchall()]    
    context = {'labs': lab, 'lab_block':lab_block}
    if request.method == 'POST':
        form = request.POST.get('form_name')
        if form == "block":
            id = request.POST.get('dir_id')
            print(id)
            directeur = Personne.objects.get(id =id)
            directeur.is_active = False
            directeur.save()
            return redirect('lab_management')
        elif form == "active":
            id = request.POST.get('dir_id')
            print(id)
            directeur = Personne.objects.get(id =id)
            directeur.is_active = True
            directeur.save()
            return redirect('lab_management')
        elif form == "update":
            id = request.POST.get('lab_id')
            lab_name = request.POST.get('lab_name')
            date_fin = request.POST.get('date_fin')
            prix = request.POST.get('prix')

            print(date_fin)
            labo = Laboratoire.objects.get(id = id)
            labo.nom = lab_name
            labo.save()
            abbonment = Abonnement.objects.get(id_lab = id)
            date_old = abbonment.date_fin
            date_fin = datetime.strptime(date_fin, "%Y-%m-%d")
            if date_old == date_fin.date():
                print("same date")
                abbonment.montant = prix
                abbonment.save()
            else :
                abbonment.date_fin = date_fin
                abbonment_montant = abbonment.montant
                prix_float = float(prix)
                new_prix = abbonment_montant + Decimal(prix_float)
                abbonment.montant = new_prix
                abbonment.save()
            return redirect('lab_management')
        elif form == "delet":
            id = request.POST.get('dir_id')
            laboratoire = Laboratoire.objects.get(id = id) 
            laboratoire.delete()
            return redirect('lab_management')
    return render(request, 'admin/lab_managment.html',context)



def add_lab(request):
    print("im here")
    if request.method == 'POST':
        print("im her21e")
        lab = request.POST.get('lab')
        print(lab)
        date_debut = request.POST.get('date_debut')
        date_fin = request.POST.get('date_fin')
        prix = request.POST.get('prix')
        id = request.POST.get('id')
        fname = request.POST.get('fname')
        lname = request.POST.get('lname')
        date_birth = request.POST.get('date_birth')
        place_birth = request.POST.get('place_birth')
        gender = request.POST.get('gender')
        email = request.POST.get('email')
        num_phone = request.POST.get('num_phone')
        max_id = Laboratoire.objects.aggregate(max_id=Max('id'))['max_id']
        new_id = max_id + 1 if max_id is not None else 1001
        lab = Laboratoire.objects.create(id =new_id, nom  = lab)
        Abonnement.objects.create(date_debut=date_debut,date_fin = date_fin, montant= prix, id_lab = lab)
        Username = generate_username()
        Passworld = generate_password()
        subject = 'New Account Created'
        message = f'Hi Patient, a new account has been created with the following credentials:\n\nUsername: {Username}\nPassword: {Passworld}'

        
        directeur = Personne()
        directeur.id = id
        directeur.nom = lname
        directeur.prenom = fname
        directeur.sex = gender
        directeur.num_telephone = num_phone
        directeur.date_naissance = date_birth
        directeur.lieu_naissance = place_birth
        directeur.email = email
        directeur.nom_utilisateur = Username
        directeur.is_active = True
        directeur.set_password(Passworld)
        directeur.save()
        send_mail(
            subject=subject,
            message=message,
            from_email=settings.EMAIL_HOST_USER,
            recipient_list=[email],
            fail_silently=False,
        )
        Directeur.objects.create(id=directeur, id_lab = lab)
        return redirect('lab_management')
    return render(request, 'admin/add_labb.html')



def validation(request):
    with connection.cursor() as cursor:
        cursor.callproc("get_demande_lab")

        columns = [column[0] for column in cursor.description]
        lab = [dict(zip(columns, row)) for row in cursor.fetchall()]
        context = {'labs': lab}
        if request.method == 'POST':
            lab_id = request.POST.get('branche_id')
            if 'reject' in request.POST:
                der = Personne.objects.get(id = Directeur.objects.get(id_lab = lab_id ).id.id)
                subject = 'result'
                message = f'your demende of lab is rejcted, '

                email = EmailMessage(
                    subject=subject,
                    body=message,
                    from_email=settings.EMAIL_HOST_USER,
                    to=[der.email],
                )
                email.send()
                der.delete()
            elif 'accepte' in request.POST: 
                print('accepte') 
                user = Personne.objects.get(id = Directeur.objects.get(id_lab = lab_id ).id.id)
                token = default_token_generator.make_token(user)
                uid = urlsafe_base64_encode(force_bytes(user.id))
                reset_link = request.build_absolute_uri('/login/payment/{}/{}'.format(uid, token))
                send_reset_password_email(user.email, reset_link)
                
                return redirect('lab_management')
    return render(request, 'admin/demmande_activation.html',context)


def send_reset_password_email(email, reset_link):
    subject = 'payment account'
    html_message = render_to_string('admin/payment_dir_email.html', {'reset_link': reset_link})
    plain_message = strip_tags(html_message)
    from_email = settings.EMAIL_HOST_USER  
    recipient_list = [email]
    send_mail(subject, plain_message, from_email, recipient_list, html_message=html_message)


def statistique(request):
    with connection.cursor() as cursor:
        cursor.callproc("get_lab", [True])

        columns = [column[0] for column in cursor.description]
        lab = [dict(zip(columns, row)) for row in cursor.fetchall()]
    with connection.cursor() as cursor:
        cursor.callproc("get_lab", [False])

        columns = [column[0] for column in cursor.description]
        lab_block = [dict(zip(columns, row)) for row in cursor.fetchall()]   
    count_lab = len(lab)
    count_lab_block = len(lab_block)

    patient = Patient.objects.filter()
    with connection.cursor() as cursor:
        cursor.callproc("get_demande_lab")

        columns = [column[0] for column in cursor.description]
        demendes = [dict(zip(columns, row)) for row in cursor.fetchall()]
    demende = len(demendes)
    abonnements = Abonnement.objects.filter()
    prix = 0
    for abonnement in abonnements:
        if abonnement.montant is not None:
            prix = prix + abonnement.montant
    nblab = Laboratoire.objects.filter().count()
    
    
    abonnements = Abonnement.objects.filter(statut='actif')

    montant_data = []
    date_data = []

    for abonnement in abonnements:
        montant_data.append(int(abonnement.montant))
        date_data.append(abonnement.date_debut.strftime('%Y-%m-%d'))

    print(montant_data,date_data)
    context = {'prix': prix, 'demende':demende,'nblab':nblab, 'client':patient.count(),'count_lab':count_lab, 'count_lab_block':count_lab_block, 
               'data_name1':json.dumps(date_data), 'data_chart1':json.dumps(montant_data)}
    return render(request, 'admin/statistique.html',context)

def admin_logout(request):
    logout(request)
    return redirect('admin_login')