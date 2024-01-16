import base64
from datetime import date, datetime, timedelta
import os
from django.contrib.auth import update_session_auth_hash
from django.http import FileResponse, HttpResponse, JsonResponse
from django.shortcuts import redirect, render
from django.contrib.auth.decorators import login_required
from django.core.mail import send_mail
from quick_lab import settings
from login.models import Employe, Infirmier, MedecinChef, Patient, Personne, Receptionniste
from patient.models import Canaux, Communication, Facture, Payment, RendezVous
from directeur.models import Branche, Laboratoire, PrixAnalyse, TypeAnalyse
from directeur.backend import generate_password, generate_username
from accueill.models import Notification
from patient.bakends import assign_workload
from receptionniste.ocr.front import ocr_front
from receptionniste.ocr.back import ocr_back
from .backends import calculate_age
from django.contrib.auth import logout
from django.contrib import messages
from django.db import connection
from django.utils import timezone
import pytz
from googletrans import Translator
from barcode import Code39
from barcode.writer import ImageWriter
from django.template.loader import get_template
import subprocess
import stripe
from django.core.mail import EmailMessage

# Create your views here.

@login_required
def homereceptionniste(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homeinfirmier')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Receptionniste.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                email = request.user.get_email()
               
                if request.method == 'POST': 
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
                    # Print the results
                context = {'name': name, 'fname':fname, 'lname': lname}
                return render(request, 'receptionniste/homeReceptionniste.html', context)

@login_required
def account_rec(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homeinfirmier')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Receptionniste.objects.filter(id=employe.id).exists():
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                name = request.user.get_full_name()
                email = request.user.get_email()
                num = request.user.get_num_telefone()
                last_login = request.user.get_last_login()
                date_cretion = request.user.get_cration_date()
                date_birth = request.user.get_date_birth()
                sex = request.user.get_sex()
                two_factor = request.user.two_factor()
                
                context = {'fname':fname,'lname':lname, 'name': name, 'email':email, 'num':num, 'last_login': last_login, 'date_cretion':date_cretion,
                           'date_birth': date_birth, 'sex': sex, 'two_factor':two_factor}
                if request.method == 'POST':
                    form_name = request.POST.get('form_name')
                    print(form_name ,"im here2")
                    if form_name == 'updateforme':
                        email = request.POST.get('email')
                        num_telephone = request.POST.get('mobile')
                        password = request.POST.get('password')
                        print("im here3")
                        if not request.user.check_password(password):
                            messages.error(request, 'Incorrect password. Please try again.')
                            return redirect('account_rec')
                        request.user.email = email
                        request.user.num_telephone = num_telephone
                        request.user.save()
                        print("im here5")
                        update_session_auth_hash(request, request.user)
                        return redirect('account_rec')
                    elif form_name == 'changepassword':
                        current_password = request.POST.get('currentPassword')
                        new_password = request.POST.get('newPassword')
                        new_password_confirm = request.POST.get('newPasswordConfirm')

                        if not request.user.check_password(current_password):
                            messages.error(request, 'The current password you entered is incorrect.')
                            return redirect('account_rec')

                        if new_password != new_password_confirm:
                            messages.error(request, 'The new passwords you entered do not match.')
                            return redirect('account_rec')

                        request.user.set_password(new_password)
                        request.user.save()
                        update_session_auth_hash(request, request.user)
                        messages.success(request, 'Your password has been changed successfully.')
                        return redirect('account_rec')
                    elif form_name == 'deletacount':
                        request.user.is_active = False
                        request.user.save()
                        logout(request)
                        return redirect('account_rec')
                    elif form_name == 'two_factor':
                        two_factor = request.POST.get('two_factor')
                        id = request.user.id
                        personne = Personne.objects.get(pk=id)
                        if two_factor is None:
                            personne.two_factor_enabled = False
                            personne.save()
                        else : 
                            personne.two_factor_enabled = True
                            personne.save()
                        return redirect('account_rec')
                return render(request, 'receptionniste/account.html', context)


            
@login_required
def appointment(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homeinfirmier')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Receptionniste.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                today = date.today()
                appointments = RendezVous.objects.filter(
                    branche__id=employe.id_branche.id,
                    date__gte=today
                ).order_by('date', 'heur')

                appointment_data = []

                for appointment in appointments:
                    patient = Patient.objects.get(id=appointment.id_patient.id)
                    personne = Personne.objects.get(id=patient.id.id)
                    patient_name = f"{personne.nom} {personne.prenom}"
                    age = calculate_age(personne.date_naissance)
                    appointment_data.append({'id': appointment.id,
                                             'date': appointment.date,
                                             'heur': appointment.heur,
                                             'id_patinet': personne.id,
                                             'patient_name': patient_name,
                                             'patient_nom' : personne.nom,
                                             'patient_prenom' : personne.prenom,
                                             'etat': appointment.etat,
                                             'purpose': appointment.purpose,
                                             'age': age})
                context = {'name': name, 'fname':fname, 'lname': lname,'appointment_data': appointment_data,}
                if request.method == 'POST':
                    appointment_id = request.POST['appointment_id']
                    new_status = request.POST['status']
                    appointment = RendezVous.objects.get(id=appointment_id)
                    appointment.etat = new_status
                    
                    if new_status == 'urgent':
                        # get the number of appointments per hour for the branch
                        num_rdv = Branche.objects.get(id=appointment.branche_id).num_rdv
                                
                        # calculate the delay time per appointment in minutes
                        duree_rdv = 60 / num_rdv
                                
                        # update the statuses of subsequent appointments
                        rdv_list = RendezVous.objects.filter(
                            date=appointment.date, branche_id=appointment.branche_id, 
                            heur__gte=appointment.heur).order_by('heur')
                        delay = 0
                        for rdv in rdv_list:
                            rdv_datetime = datetime.combine(rdv.date, rdv.heur)
                            rdv_datetime += timedelta(minutes=delay*duree_rdv)
                            rdv.heur = rdv_datetime.time()
                            rdv.etat = 'delay'
                            rdv.save()
                            delay += 1
                    appointment.save()
                    return redirect('appointment')
                return render(request, 'receptionniste/Appointments.html', context)
            
@login_required
def add_appointment(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homeinfirmier')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Receptionniste.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                barnch = Branche.objects.get(id = employe.id_branche.id)
                today = datetime.now().date()
                rdvs = RendezVous.objects.filter(branche=barnch, date__gte=today)
                branch_rdv_details = [
                    rdv.date.strftime("%Y-%m-%d") + ">" + rdv.heur.strftime("%H:%M")
                    for rdv in rdvs
                    ]
                analyses = PrixAnalyse.objects.filter(id_lab=barnch.labo).values('code_analyse__code', 'code_analyse__nom')
                context = {'name': name, 'fname':fname, 'lname': lname, "analyses":analyses,'rdv_booked':branch_rdv_details, 'barnch':barnch}
                if request.method == 'POST':
                    # Get the form inputs from the request.POST dictionary
                    rdv_time = request.POST['rdv_time']
                    rdv_date = request.POST['rdv_date']
                    analyse = request.POST.getlist('analyse')
                    type_rdv = request.POST['type_rdv']
                    id = request.POST['id']
                    fname = request.POST['fname']
                    lname = request.POST['lname']
                    date_birth = request.POST['date_birth']
                    place_birth = request.POST['place_birth']
                    gender = request.POST['gender']
                    email = request.POST['email']
                    num_phone = request.POST['num_phone']
                    type = request.POST['purpose']
                    
                    analyse = "$".join(analyse)
                    if Patient.objects.filter(id=id):
                            patient = Patient.objects.get(id=id)
                            if type == "blood test": 
                                rdv = RendezVous.objects.create(
                                    date=rdv_date,
                                    heur=rdv_time,
                                    analyes=analyse,
                                    type_rdv=type_rdv,
                                    etat='normal',
                                    id_patient=patient,
                                    branche=barnch,
                                    purpose = type
                                )
                                rdv.save()
                                assign_workload(rdv.id, barnch.id)
                            else:
                                rdv = RendezVous.objects.create(
                                    date=rdv_date,
                                    heur=rdv_time,
                                    analyes="BBT$BHBSA$BHCA$BHIV$BTPHA",
                                    type_rdv='labo',
                                    etat='normal',
                                    id_patient=patient,
                                    branche=barnch,
                                    purpose = type
                                )
                                rdv.save()
                                assign_workload(rdv.id, barnch.id)
                                return redirect('appointment')
                    else:
                        if Personne.objects.filter(email=email):
                            messages.error(request, "Email already registered!")
                            return redirect('addappointment')
                        
                        if Personne.objects.filter(num_telephone=num_phone):
                            messages.error(request, "phone already exists! Please try a different number.")
                            return redirect('addappointment')
                        Username = generate_username()
                        Passworld = generate_password()
                        subject = 'New Account Created'
                        message = f'Hi Patient, a new account has been created with the following credentials:\n\nUsername: {Username}\nPassword: {Passworld}'
                        
                        
                        myPatient = Personne()
                        myPatient.id = id
                        myPatient.nom = lname
                        myPatient.prenom = fname
                        myPatient.sex = gender
                        myPatient.num_telephone = num_phone
                        myPatient.date_naissance = date_birth
                        myPatient.lieu_naissance = place_birth
                        myPatient.email = email
                        myPatient.nom_utilisateur = Username
                        myPatient.is_active = True
                        myPatient.two_factor_enabled = False 
                        myPatient.set_password(Passworld)
                        myPatient.save()
                        send_mail(
                                subject=subject,
                                message=message,
                                from_email=settings.EMAIL_HOST_USER,
                                recipient_list=[email],
                                fail_silently=False,
                            )
                        mypatient = Patient.objects.create(id=myPatient)
                        if type == "blood test":
                            rdv = RendezVous.objects.create(
                                date=rdv_date,
                                heur=rdv_time,
                                analyes=analyse,
                                type_rdv='labo',
                                etat='normal',
                                id_patient=mypatient,
                                branche=barnch,
                                purpose = type
                            )
                            rdv.save()
                            assign_workload(rdv.id, barnch.id)
                                
                        else:
                            rdv = RendezVous.objects.create(
                                date=rdv_date,
                                heur=rdv_time,
                                analyes="BBT$BHBSA$BHCA$BHIV$BTPHA",
                                type_rdv=type_rdv,
                                etat='normal',
                                id_patient=mypatient,
                                branche=barnch,
                                purpose = type
                            )
                            rdv.save()
                            assign_workload(rdv.id, barnch.id)
                            return redirect('appointment')
                    if 'cash payment' in request.POST:
                        code_list = analyse.split("$") # remove last empty element

                        total_price = 0

                                # loop over the code list
                        for code in code_list:
                                # retrieve the price of the analysis from the PrixAnalyse model
                            prix_analyse = PrixAnalyse.objects.filter(code_analyse__code=code, id_lab=barnch.labo.id).first()
                            price = prix_analyse.prix
                                
                            total_price += price
                        hometarif = 0.00    
                        print(type_rdv)
                        if type_rdv == 'domicile':
                            total_price+= 50
                            hometarif = 50.00
                        print(total_price)
                        payment = Payment.objects.create(
                            rdv=rdv,
                            charge_id="0000",
                            amount=total_price,
                            card_last4="0000",
                            card_brand="cash",
                            payment_status='success',
                            created_at=datetime.now()
                        )
                        payment.save()
                                #facture
                        branch_id = barnch.id
                        today = datetime.today().strftime('%Y%m%d')
                        now_time = datetime.now().strftime('%H%M%S')
                        invoice_number = int(f"{branch_id:04d}{today}{now_time}")
                        print(invoice_number)
                        template = get_template('patient/invoice.html')
                        barcode_value = str(invoice_number)
                        barcode = Code39(barcode_value, writer=ImageWriter())
                        barcode_file_path = os.path.join('media', 'barcode', '{}'.format(invoice_number))
                        barcode.save(barcode_file_path)

                        analyses = analyse.split("$")
                        name_analyses = TypeAnalyse.objects.filter(code__in=analyses)
                        
                        labo = Laboratoire.objects.get(id=barnch.labo.id)
                        print(barcode_file_path)
                        barcode_file_path = barcode_file_path +".png"
                        today = datetime.today()
                        current_date = today.date()
                        current_time = today.time()
                        date = str(current_date) + " "+ str(current_time)
                        patient = Personne.objects.get(id=id)
                        context = {
                            'f': {'number': invoice_number, 'date':date },
                            'Laboratory': {'labo_name': labo.nom},
                            'branch': {'id': barnch.id, 'localisation': barnch.localisation, "tel": barnch.num_telephone, "email": barnch.email},
                            'patient': {'id': patient.id, 'name': patient.prenom + " "+ patient.nom , 'email': patient.email, 'tel': patient.num_telephone},
                            'rdv': {'id': rdv.id, 'date': rdv.date, 'time': rdv.heur},
                            'name_analyses': name_analyses,
                            'total': total_price,
                                
                            'hometarif': hometarif,
                            'barcode_image': barcode_file_path,
                        }
                                
                                
                                
                                
                                
                        html_string = template.render(context)
                                
                                



                        filename = 'invoice-{}.pdf'.format(invoice_number)
                        output_dir = os.path.join('pdf','invoices')
                        os.makedirs(output_dir, exist_ok=True)
                        file_path = os.path.join(output_dir, filename)
                        
                        command = ['wkhtmltopdf', '-', file_path]
                            
                                # Assuming `html_string` contains the HTML content for the invoice
                        try:
                            html_bytes = html_string.encode('utf-8')  # Encode html_string as bytes
                            subprocess.run(command, input=html_bytes, check=True)
                            subject = 'Your Invoice'
                            message = f'Hi Patient,Please find attached your invoice for the medical services provided.'
                            
                            email = EmailMessage(
                                subject=subject,
                                body=message,
                                from_email=settings.EMAIL_HOST_USER,
                                to=[request.user.email],
                                attachments=[(filename, open(file_path, 'rb').read(), 'application/pdf')],
                            )
                            email.send()
                            # response = FileResponse(open(file_path, 'rb'), content_type='application/pdf')
                            # response['Content-Disposition'] = 'inline; filename={filename}'
                            facture = Facture.objects.create(
                                id = invoice_number,
                                statut='payer',
                                chemin_facture = file_path,
                                prix = total_price,
                                rdv_id=rdv.id,
                            )
                            facture.save() 
                            appointment_url = '/receptionniste/appointment/' 
                            file_url = '/pdf/invoices/'+ filename         
                            print('PDF successfully generated.')
                            context = {
                                'appointment_url': appointment_url,
                                'file_url': file_url,
                            }
                            return render(request, 'receptionniste/facture_open.html', context)
                        except subprocess.CalledProcessError as e:
                            print('Error generating PDF:', e)
                    elif 'Card payment' in request.POST:
                        analyse_codes = analyse.split('$')
                        total_price = 0

                                # loop over the code list
                        for code in analyse_codes:
                                # retrieve the price of the analysis from the PrixAnalyse model
                            prix_analyse = PrixAnalyse.objects.filter(code_analyse__code=code, id_lab=barnch.labo.id).first()
                            price = prix_analyse.prix
                                
                            total_price += price
                        hometarif = 0.00    
                        print(type_rdv)
                        if type_rdv == 'domicile':
                            total_price+= 50
                            hometarif = 50.00
                        lab = Laboratoire.objects.get(branche__id=barnch.id)

                        # Retrieve the corresponding PrixAnalyse objects
                        prix_analyse = PrixAnalyse.objects.filter(id_lab=lab, code_analyse__in=analyse_codes)

                        # Retrieve the prices and names for the analyses
                        prices = [pa.prix for pa in prix_analyse]
                        names = [pa.code_analyse.nom for pa in prix_analyse]
                        zipped_data = zip(names, prices)
                        context = {'name': name, 'fname':fname, 'lname': lname, "analyses":analyses, 'id_rdv':rdv.id, 'zipped_data':zipped_data, 'prix':total_price}
                        return render(request, 'receptionniste/payment_online.html', context)
                    return redirect('appointment')
            return render(request, 'receptionniste/add_appointment.html', context)
        
@login_required
def result(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homeinfirmier')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Receptionniste.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                if request.method == 'POST':
                    id = request.POST['id']
                    date = request.POST['date']
                    print(id, date)
                    if id != '' or  date != '':
                        if id == '':
                            with connection.cursor() as cursor:
                                cursor.callproc("SearchResult", [None, date,Employe.objects.get(id_prs=user.id).id_branche.id])

                                columns = [column[0] for column in cursor.description]
                                result = [dict(zip(columns, row)) for row in cursor.fetchall()]
                        elif date == '':
                            with connection.cursor() as cursor:
                                cursor.callproc("SearchResult", [id,None,Employe.objects.get(id_prs=user.id).id_branche.id])

                                columns = [column[0] for column in cursor.description]
                                result = [dict(zip(columns, row)) for row in cursor.fetchall()]
                        else:
                            with connection.cursor() as cursor:
                                cursor.callproc("SearchResult", [id,date,Employe.objects.get(id_prs=user.id).id_branche.id])

                                columns = [column[0] for column in cursor.description]
                                result = [dict(zip(columns, row)) for row in cursor.fetchall()]
                    else:
                        algeria_tz = pytz.timezone('Africa/Algiers')
                        now = timezone.now().astimezone(algeria_tz)
                        date = now.date()
                        print(date)
                        with connection.cursor() as cursor:
                            cursor.callproc("SearchResult", [None, date,Employe.objects.get(id_prs=user.id).id_branche.id])

                            columns = [column[0] for column in cursor.description]
                            result = [dict(zip(columns, row)) for row in cursor.fetchall()]
                else:
                    algeria_tz = pytz.timezone('Africa/Algiers')
                    now = timezone.now().astimezone(algeria_tz)
                    date = now.date()
                    print(date)
                    with connection.cursor() as cursor:
                        cursor.callproc("SearchResult", [None, date,Employe.objects.get(id_prs=user.id).id_branche.id])

                        columns = [column[0] for column in cursor.description]
                        result = [dict(zip(columns, row)) for row in cursor.fetchall()]
                context = {'name': name, 'fname':fname, 'lname': lname, 'results':result}
                return render(request, 'receptionniste/Results.html', context)



@login_required
def channels(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif Employe.objects.filter(id_prs=request.user.id).exists():
        employe = Employe.objects.get(id_prs=request.user.id)
        if Infirmier.objects.filter(id=employe.id).exists():
            return redirect('homeinfirmier')
        elif MedecinChef.objects.filter(id=employe.id).exists():
            return redirect('homemedecinchef')
        elif Receptionniste.objects.filter(id=employe.id).exists():
    
            name = request.user.get_full_name()
            fname = request.user.get_first_name()
            lname = request.user.get_last_name()
            
            context = {'name': name, 'fname':fname, 'lname': lname,}
            return render(request, 'receptionniste/channels.html', context)
    
    
def channels_data_view(request):
    
    mockChannels = []

    channels_data = Canaux.objects.filter(branch=(Employe.objects.get(id_prs=request.user.id)).id_branche.id).values('id','pat')

    # Iterate over the channels data and populate the mockChannels list
    for channel_data in channels_data:
        patient = Personne.objects.get(id = channel_data['pat'] )
        channel = {
            "id": channel_data['id'],
            "name": patient.prenom + " " + patient.nom ,
            "favorite": False,
            "sender": True,
            "messages": [],
            "latestMessage": ""  # Initialize as empty string
        }

        # Retrieve the latest message for the current channel
        latest_date = Communication.objects.filter(canaux_id=channel_data['id']).order_by('-date').values_list('date', flat=True).first()
        latest_date += timedelta(hours=1)
        if latest_date:
            channel['latestMessage'] = latest_date.strftime('%I:%M %p')

        # Append the channel to the mockChannels list
        
        emetteur = Communication.objects.filter(canaux_id=channel_data['id']).values_list('emetteur', flat=True).last()
        if emetteur == 'laboratoire':
            channel['sender'] = True
        else:
            channel['sender'] = False
        mockChannels.append(channel)
    mockChannels = sorted(mockChannels, key=lambda x: datetime.strptime(x['latestMessage'], '%I:%M %p'), reverse=True)
    return JsonResponse(mockChannels, safe=False)


@login_required
def messages_res(request,id):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif Employe.objects.filter(id_prs=request.user.id).exists():
        employe = Employe.objects.get(id_prs=request.user.id)
        if Infirmier.objects.filter(id=employe.id).exists():
            return redirect('homeinfirmier')
        elif MedecinChef.objects.filter(id=employe.id).exists():
            return redirect('homemedecinchef')
        elif Receptionniste.objects.filter(id=employe.id).exists():
            name = request.user.get_full_name()
            fname = request.user.get_first_name()
            lname = request.user.get_last_name()
            
            channels = Canaux.objects.get(id= id)
            patient = Personne.objects.get(id = channels.pat.id.id)
            name_channel = patient.prenom + " " + patient.nom 
            if request.method == 'POST':
                algeria_tz = pytz.timezone('Africa/Algiers')
                now = timezone.now().astimezone(algeria_tz)
                date_now =  now.strftime("%Y-%m-%d %H:%M:%S")
                message = request.POST.get('message')
                Communication.objects.create(
                    emetteur = 'laboratoire',
                    message = message,
                    date = date_now,
                    canaux = channels
                )
                response_data = {'status': 'success'}
                return JsonResponse(response_data)
            context = {'name': name, 'fname':fname, 'lname': lname, 'id':id ,'name_channel':name_channel}
            return render(request, 'receptionniste/messages.html', context)
    
    
    


def messages_data(request,id):
    
    mockChannels = []

    channels_data = Communication.objects.filter(canaux=id).values('emetteur','message','date')
    # Iterate over the channels data and populate the mockChannels list
    for channel_data in channels_data:
        
        channel = {

            "createdOn": channel_data['date'],
            "channel": id,
            "own": False,
            "text": channel_data['message'],
            
        }


        
        if channel_data['emetteur'] == "laboratoire":
            channel['own'] = True
        else:
            channel['own'] = False
        mockChannels.append(channel)
    return JsonResponse(mockChannels, safe=False)

def ocr(request):
    results_front = ocr_front()
    results_back = ocr_back()
    var1, var2, var3, var4, var5 = results_front
    id = var1.rstrip()
    date = var2.rstrip()
    date_obj = datetime.strptime(date, "%Y%m%d")

    # Convert the datetime object to the MySQL date format
    date = date_obj.strftime("%Y-%m-%d")
    groupage = var3.rstrip()
                
    sex = var4.rstrip()
                
    source_lang = "arabic"
    target_lang = "french"
    translator = Translator()
    translation = translator.translate(sex, src=source_lang, dest=target_lang)
    sex = translation.text

    place = var5.rstrip()
    source_lang = "arabic"
    target_lang = "french"
    translator = Translator()
    translation = translator.translate(place, src=source_lang, dest=target_lang)
    place = translation.text
    var1, var2, var3 = results_back
    laname = var1.rstrip()
    finame = var2.rstrip()

    # Create a dictionary containing the retrieved data
    data = {
        'id': id,
        'date': date,
        'groupage': groupage,
        'sex': sex,
        'place': place,
        'finame': finame,
        'laname': laname,
    }
    print(data)

    # Return the data as a JSON response
    return JsonResponse(data)


def card_pay(request):
    
    if request.method == 'POST':           
        rdv_id = request.POST['rdv_id']
        prix = request.POST.get('prix')
        carte = request.POST.get('num_carte')
        date_carte = request.POST.get('date_exp')
        code_carte = request.POST.get('code_s')
        year, month = date_carte.split("-")
        rdv = RendezVous.objects.get(id=rdv_id)
        prix = float(prix) 
        print(prix)
        stripe.api_key = settings.STRIPE_SECRET_KEY
        # Create a test token
        token = stripe.Token.create(
        
        card={

            "number": carte,
            "exp_month": month,
            "exp_year": year,
            "cvc": code_carte,
                        
            },
                    
        )
        try:
            # Use the test token to make a test charge
            charge = stripe.Charge.create(
            amount=int(prix*100),
            currency='usd',
            description='Payment',
            source=token.id,

            )

            payment = Payment.objects.create(
                rdv=rdv,
                charge_id=charge.id,
                amount=prix,
                card_last4=charge.source.last4,
                card_brand=charge.source.brand,
                payment_status='success',
                created_at=datetime.now()
            )
            payment.save()
            analyse = rdv.analyes

            barnch = Branche.objects.get(id= rdv.branche.id)
            code_list = analyse.split("$") # remove last empty element

            total_price = 0

                    # loop over the code list
            for code in code_list:
                    # retrieve the price of the analysis from the PrixAnalyse model
                prix_analyse = PrixAnalyse.objects.filter(code_analyse__code=code, id_lab=barnch.labo.id).first()
                price = prix_analyse.prix

                total_price += price
            hometarif = 0.00    
            if rdv.type_rdv == 'domicile':
                total_price+= 50
                hometarif = 50.00
            print(total_price)
            
            payment.save()
                    #facture
            branch_id = barnch.id
            today = datetime.today().strftime('%Y%m%d')
            now_time = datetime.now().strftime('%H%M%S')
            invoice_number = int(f"{branch_id:04d}{today}{now_time}")
            print(invoice_number)
            template = get_template('patient/invoice.html')
            barcode_value = str(invoice_number)
            barcode = Code39(barcode_value, writer=ImageWriter())
            barcode_file_path = os.path.join('media', 'barcode', '{}'.format(invoice_number))
            barcode.save(barcode_file_path)

            analyses = analyse.split("$")
            name_analyses = TypeAnalyse.objects.filter(code__in=analyses)

            labo = Laboratoire.objects.get(id=barnch.labo.id)
            print(barcode_file_path)
            barcode_file_path = barcode_file_path +".png"
            today = datetime.today()
            current_date = today.date()
            current_time = today.time()
            date = str(current_date) + " "+ str(current_time)
            patient = Personne.objects.get(id=rdv.id_patient.id.id)
            context = {
                'f': {'number': invoice_number, 'date':date },
                'Laboratory': {'labo_name': labo.nom},
                'branch': {'id': barnch.id, 'localisation': barnch.localisation, "tel": barnch.num_telephone, "email": barnch.email},
                'patient': {'id': patient.id, 'name': patient.prenom + " "+ patient.nom , 'email': patient.email, 'tel': patient.num_telephone},
                'rdv': {'id': rdv.id, 'date': rdv.date, 'time': rdv.heur},
                'name_analyses': name_analyses,
                'total': total_price,
                'transaction': charge.id,
                'hometarif': hometarif,
                'barcode_image': barcode_file_path,
            }





            html_string = template.render(context)





            filename = 'invoice-{}.pdf'.format(invoice_number)
            output_dir = os.path.join('pdf','invoices')
            os.makedirs(output_dir, exist_ok=True)
            file_path = os.path.join(output_dir, filename)

            command = ['wkhtmltopdf', '-', file_path]

                    # Assuming `html_string` contains the HTML content for the invoice
            try:
                html_bytes = html_string.encode('utf-8')  # Encode html_string as bytes
                subprocess.run(command, input=html_bytes, check=True)
                subject = 'Your Invoice'
                message = f'Hi Patient, Please find attached your invoice for the medical services provided.'

                email = EmailMessage(
                    subject=subject,
                    body=message,
                    from_email=settings.EMAIL_HOST_USER,
                    to=[request.user.email],
                    attachments=[(filename, open(file_path, 'rb').read(), 'application/pdf')],
                )
                email.send()
                # response = FileResponse(open(file_path, 'rb'), content_type='application/pdf')
                # response['Content-Disposition'] = 'inline; filename={filename}'
                facture = Facture.objects.create(
                    id = invoice_number,
                    statut='payer',
                    chemin_facture = file_path,
                    prix = total_price,
                    rdv_id=rdv.id,
                )
                facture.save() 
                appointment_url = '/receptionniste/appointment/' 
                file_url = '/pdf/invoices/'+ filename         
                print('PDF successfully generated.')
                context = {
                    'appointment_url': appointment_url,
                    'file_url': file_url,
                }
                return render(request, 'receptionniste/facture_open.html', context)
            except subprocess.CalledProcessError as e:
                print('Error generating PDF:', e)
            # Retrieve the corresponding PrixAnalyse objects
            
        except stripe.error.CardError as e:
            messages.error(request, e.error.message)
    
    return redirect('appointment')


@login_required
def notification_receptioniste(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homeinfirmier')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Receptionniste.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                
                
                perssone = Personne.objects.get(id=request.user.id)
                notifications = Notification.objects.filter(is_read=False,id_prs=perssone.id)
                print(notifications)
                if request.method == 'POST':
                    for notification in notifications :
                        notification.is_read = True 
                        notification.save()
                    return redirect('notification_receptioniste')
                # Print the results
                context = {'name': name, 'fname':fname, 'lname': lname,'notifications' : notifications}
                return render(request, 'receptionniste/notification.html', context)
   

@login_required
def signout(request):
    logout(request)
    messages.success(request, 'You have successfully logged out.')
    return redirect('/')