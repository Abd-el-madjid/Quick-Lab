from django.template.loader import get_template
from barcode import Code39
import base64
from datetime import datetime, timedelta, date
from django.core.mail import EmailMessage
import json
import os
from quick_lab import settings
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render,redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from django.contrib import messages
from django.contrib.auth import update_session_auth_hash
import pytz
import stripe
from login.models import Employe, Infirmier, MedecinChef, Patient, Personne, Receptionniste
from directeur.models import Laboratoire, Branche, PrixAnalyse, TypeAnalyse, ClientLabo
from accueill.models import Notification
from.tasks import send_email_for_tomorrow_rdv
from receptionniste.backends import calculate_age
from .bakends import assign_workload, prediction_Anemia, prediction_Heart, prediction_Liver, prediction_diabet, recomondation_Anemia, recomondation_Heart, recomondation_Liver, recomondation_diabet
from .models import Annulation, Canaux, Communication, Conseille, Facture, Payment, RendezVous, TravailInfermier


from barcode.writer import ImageWriter
from xhtml2pdf import pisa
from django.utils import timezone   
from decimal import Decimal
import subprocess
from django.db import connection
from cryptography.fernet import Fernet
from io import BytesIO
import qrcode
from django.http import JsonResponse
import numpy as np
from AI.model.diabet import prediction_dibaset
from AI.model.liver import prediction_liver
from AI.model.heart import heart_prediction
from AI.model.anemia import prediction_anemia



@login_required
def homepatient(request):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif hasattr(request.user, 'patient'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        if request.method == 'POST':
        
               email = request.user.get_email()
               

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
               return redirect('homepatient')
        context = {'name': name, 'fname':fname, 'lname': lname}
        return render(request, 'patient/homepatient.html', context)

@login_required
def accountpatient(request):
    if hasattr(request.user, 'directeur'):
        return render(request, 'directeur/homedirecteur.html')
    elif hasattr(request.user, 'patient'):
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
        patient = Patient.objects.get(id=request.user.id)
        type_sang = patient.type_sang
        maladie = patient.maladie
        context = {'name': name, 'email':email, 'num':num, 'last_login': last_login, 'date_cretion':date_cretion, 'date_birth': date_birth, 'sex': sex, 'type_sang':type_sang, 'fname':fname, 'lname': lname, 'maladie':maladie, 'two_factor':two_factor}
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
                    print("im here4")
                    return redirect('account')
                request.user.email = email
                request.user.num_telephone = num_telephone
                request.user.save()
                print("im here5")
                update_session_auth_hash(request, request.user)
                return redirect('account')
            elif form_name == 'changepassword':
                current_password = request.POST.get('currentPassword')
                new_password = request.POST.get('newPassword')
                new_password_confirm = request.POST.get('newPasswordConfirm')

                if not request.user.check_password(current_password):
                    messages.error(request, 'The current password you entered is incorrect.')
                    return redirect('change_password')

                if new_password != new_password_confirm:
                    messages.error(request, 'The new passwords you entered do not match.')
                    return redirect('change_password')

                request.user.set_password(new_password)
                request.user.save()
                update_session_auth_hash(request, request.user)
                messages.success(request, 'Your password has been changed successfully.')
                return redirect('account')
            elif form_name == 'deletacount':
                request.user.is_active = False
                request.user.save()
                logout(request)
                return redirect('account')
            elif form_name == 'updatedetail':

                id = request.user.id

                # Retrieve the corresponding Personne object
                personne = Personne.objects.get(pk=id)

                # Update the fields of the Personne object with the new values from the POST request
                personne.nom = request.POST.get('firstname')
                personne.prenom = request.POST.get('surname')
                day_birth = request.POST.get('day')
                month_birth = request.POST.get('month')
                year_birth = request.POST.get('year')
                personne.date_naissance = f"{year_birth}-{month_birth}-{day_birth}"
                personne.sex = request.POST.get('gender')

                # Save the updated Personne object
                personne.save()

                patient = Patient.objects.get(pk=id)
                patient.type_sang = request.POST.get('type_sang')
                patient.maladie = request.POST.get('illnesses')
                patient.save()


                messages.success(request, 'Your profile has been updated successfully!')
                return redirect('account')
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
                return redirect('account')
        return render(request, 'patient/account.html', context)



@login_required
def book_rdv(request):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif hasattr(request.user, 'patient'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        analyses = TypeAnalyse.objects.all()
        laboratoires = Laboratoire.objects.all()
        today = datetime.now().date()
        lab_info = []

        for laboratoire in laboratoires:
            client_labo = ClientLabo.objects.filter(id_patient=request.user.id, id_labo=laboratoire.id).first()

            if client_labo is None or client_labo.is_bloked == False:

                branch_rdv_details = {}
                branchs = Branche.objects.filter(labo=laboratoire)

                for branche in branchs:
                    rdvs = RendezVous.objects.filter(branche=branche, date__gte=today)
                    branch_rdv_details = '$'.join([
                        rdv.date.strftime("%Y-%m-%d") + ">" + rdv.heur.strftime("%H:%M")
                        for rdv in rdvs
                    ])

                    lab_info.append({
                        'laboratoire': laboratoire,
                        'branch':branche,
                        'branch_rdv_details': branch_rdv_details,
                    })
                
        print(lab_info)
        
        
        if request.method == 'POST':
            branch = request.POST.get('id_branch')
            type = request.POST.get('rdv_purpose')
            analyse = request.POST.get('type_analyse')
            date = request.POST.get('rdv_date')
            time = request.POST.get('rdv_time')
            place = request.POST.get('rdv_type')
            carte = request.POST.get('num_card_b')
            date_carte = request.POST.get('date_exp_b')
            code_carte = request.POST.get('code_s_b')
            type_analyse_selected = request.POST.get('typeAnalyseSelected')
                     
            
            
            
            
            
            
            if type_analyse_selected :
                filtered_laboratoires = []
                laboratoire_ids = set()  # Keep track of laboratoire IDs

                for laboratoire in laboratoires:
                    if laboratoire.id not in laboratoire_ids:
                        branches = Branche.objects.filter(labo=laboratoire)
                        matching_branches = []

                        for branch in branches:
                            prix_analyse = PrixAnalyse.objects.filter(id_lab=laboratoire, code_analyse__in=type_analyse_selected.split(","))
                            prix_analyse_count = prix_analyse.count()

                            if prix_analyse_count == len(type_analyse_selected.split(",")):
                                matching_branches.append(branch)

                        if matching_branches:
                            filtered_laboratoires.append(laboratoire)
                            laboratoire_ids.add(laboratoire.id)

                lab_info = []

                for laboratoire in filtered_laboratoires:
                    client_labo = ClientLabo.objects.filter(id_patient=request.user.id, id_labo=laboratoire.id).first()

                    if client_labo is None or client_labo.is_bloked == False:
                        branch_rdv_details = {}
                        branchs = Branche.objects.filter(labo=laboratoire)

                        for branche in branchs:
                            rdvs = RendezVous.objects.filter(branche=branche, date__gte=today)
                            branch_rdv_details = '$'.join([
                                rdv.date.strftime("%Y-%m-%d") + ">" + rdv.heur.strftime("%H:%M")
                                for rdv in rdvs
                            ])

                            lab_info.append({
                                'laboratoire': laboratoire,
                                'branch': branche,
                                'branch_rdv_details': branch_rdv_details,
                            })

               
                print(filtered_laboratoires)
                context = {
                    'name': name,
                    'fname': fname,
                    'lname': lname,
                    'lab_info': lab_info,
                    'analyses': analyses
                }

                return render(request, 'patient/Book_Appointment.html', context)


            
            if type == 'blood test' and  place == 'in the laboratory':
                year, month = date_carte.split("-")
                laboratoires = Branche.objects.get(id = branch)
                id_lab = laboratoires.labo
                code_list = analyse.split("$")[:-1]  # remove last empty element

                total_price = 0

                # loop over the code list
                for code in code_list:
                    # retrieve the price of the analysis from the PrixAnalyse model
                    prix_analyse = PrixAnalyse.objects.filter(code_analyse__code=code, id_lab=id_lab).first()
                    price = prix_analyse.prix
                    
                    total_price += price

                print(total_price)
                stripe.api_key = settings.STRIPE_SECRET_KEY
                # Create a test token
                customer = stripe.Customer.create(
                    email=request.user.email,
                )
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
                        amount=int(total_price*100),
                        currency='usd',
                        description='Payment',
                        source=token.id,

                    )
                    # store the charge_id in the database
                    analyse = analyse[:-1]
                    patient = Patient.objects.get(id=request.user.id)
                    branche = Branche.objects.get(id=branch)
                    
                    rdv = RendezVous.objects.create(
                        date=date,
                        heur=time,
                        analyes=analyse,
                        type_rdv='labo',
                        etat='normal',
                        id_patient=patient,
                        branche=branche,
                        purpose = type
                    )
                    rdv.save()
                    print("i save rdv")
                    
                    #payment information 
                    
                    payment = Payment.objects.create(
                        rdv=rdv,
                        charge_id=charge.id,
                        amount=total_price,
                        card_last4=charge.source.last4,
                        card_brand=charge.source.brand,
                        payment_status='success',
                        created_at=datetime.now()
                    )
                    payment.save()
                    
                    #facture
                    branch_id = branche.id
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

                    labo = Laboratoire.objects.get(id=branche.labo.id)
                    print(barcode_file_path)
                    barcode_file_path = barcode_file_path +".png"
                    today = datetime.today()
                    current_date = today.date()
                    current_time = today.time()
                    date = str(current_date) + " "+ str(current_time)
                    context = {
                        'f': {'number': invoice_number, 'date':date },
                        'Laboratory': {'labo_name': labo.nom},
                        'branch': {'id': branche.id, 'localisation': branche.localisation, "tel": branche.num_telephone, "email": branche.email},
                        'patient': {'id': request.user.id, 'name': name, 'email': request.user.email, 'tel': request.user.num_telephone},
                        'rdv': {'id': rdv.id, 'date': rdv.date, 'time': rdv.heur},
                        'transaction': charge.id,
                        'name_analyses': name_analyses,
                        'total': total_price,
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
                        # email.send()
                        facture = Facture.objects.create(
                            id = invoice_number,
                            statut='payer',
                            chemin_facture = file_path,
                            prix = total_price,
                            rdv_id=rdv.id,
                        )
                        facture.save()        
                        print('PDF successfully generated.')
                    except subprocess.CalledProcessError as e:
                        print('Error generating PDF:', e)
                                        
                    
                    
                    rdv_id = rdv.id  # assuming this is how you get the rdv ID
                    assign_workload(rdv_id, branch_id)
                    print(rdv_id , "the last id")
                    response_data = {'rdv_id': rdv_id, 'file_path': file_path}
                    return JsonResponse(response_data, status=200)
                
                except stripe.error.CardError as e:
                    messages.error(request, e.error.message)
            elif place == 'at home':
                year, month = date_carte.split("-")
                laboratoires = Branche.objects.get(id = branch)
                id_lab = laboratoires.labo
                code_list = analyse.split("$")[:-1]  # remove last empty element

                total_price = 0

                # loop over the code list
                for code in code_list:
                    # retrieve the price of the analysis from the PrixAnalyse model
                    prix_analyse = PrixAnalyse.objects.filter(code_analyse__code=code, id_lab=id_lab).first()
                    price = prix_analyse.prix
                    
                    total_price += price

                total_price = total_price + 50
                stripe.api_key = settings.STRIPE_SECRET_KEY
                # Create a test token
                customer = stripe.Customer.create(
                    email=request.user.email,
                )
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
                        amount=int(total_price*100),
                        currency='usd',
                        description='Payment',
                        source=token.id,

                    )
                    # store the charge_id in the database
                    analyse = analyse[:-1]
                    patient = Patient.objects.get(id=request.user.id)
                    branche = Branche.objects.get(id=branch)
                    
                    rdv = RendezVous.objects.create(
                        date=date,
                        heur=time,
                        analyes=analyse,
                        type_rdv='domicile',
                        etat='normal',
                        id_patient=patient,
                        branche=branche,
                        purpose = type
                    )
                    rdv.save()
                    print("i save rdv")
                    
                    #payment information 
                    
                    payment = Payment.objects.create(
                        rdv=rdv,
                        charge_id=charge.id,
                        amount=total_price,
                        card_last4=charge.source.last4,
                        card_brand=charge.source.brand,
                        payment_status='success',
                        created_at=datetime.now()
                    )
                    payment.save()
                    
                    #facture
                    branch_id = branche.id
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

                    labo = Laboratoire.objects.get(id=branche.labo.id)
                    print(barcode_file_path)
                    barcode_file_path = barcode_file_path +".png"
                    today = datetime.today()
                    current_date = today.date()
                    current_time = today.time()
                    date = str(current_date) + " "+ str(current_time)
                    context = {
                        'f': {'number': invoice_number, 'date':date },
                        'Laboratory': {'labo_name': labo.nom},
                        'branch': {'id': branche.id, 'localisation': branche.localisation, "tel": branche.num_telephone, "email": branche.email},
                        'patient': {'id': request.user.id, 'name': name, 'email': request.user.email, 'tel': request.user.num_telephone},
                        'rdv': {'id': rdv.id, 'date': rdv.date, 'time': rdv.heur},
                        'transaction': charge.id,
                        'name_analyses': name_analyses,
                        'hometarif': 50.00,
                        'total': total_price,
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
                        # email.send()
                        facture = Facture.objects.create(
                            id = invoice_number,
                            statut='payer',
                            chemin_facture = file_path,
                            prix = total_price,
                            rdv_id=rdv.id,
                        )
                        facture.save()        
                        print('PDF successfully generated.')
                    except subprocess.CalledProcessError as e:
                        print('Error generating PDF:', e)
                                        
                    
                    
                    rdv_id = rdv.id  # assuming this is how you get the rdv ID
                    assign_workload(rdv_id, branch_id)
                    print(rdv_id , "the last id")
                    response_data = {'rdv_id': rdv_id, 'file_path': file_path}
                    return JsonResponse(response_data, status=200)
                
                except stripe.error.CardError as e:
                    messages.error(request, e.error.message)
            elif type == 'blood donation':
                patient = Patient.objects.get(id=request.user.id)
                branche = Branche.objects.get(id=branch)
                rdv = RendezVous.objects.create(
                        date=date,
                        heur=time,
                        analyes="BBT$BHBSA$BHCA$BHIV$BTPHA",
                        type_rdv='labo',
                        etat='normal',
                        id_patient=patient,
                        branche=branche,
                        purpose = type
                    )
                rdv_id = rdv.id
                assign_workload(rdv_id, branche.id)
                rdv.save()
                return JsonResponse({'rdv_id': rdv_id})
        context = {'name': name, 'fname':fname, 'lname': lname, 'lab_info': lab_info,  'analyses':analyses}
        return render(request, 'patient/Book_Appointment.html', context)


@login_required
def your_rdv(request):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif hasattr(request.user, 'patient'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()

        rdvs = RendezVous.objects.filter(
            id_patient=request.user.id
        ).select_related(
            'branche',
            'branche__labo'
        ).order_by('-date', 'heur')
        context = {'name': name, 'fname':fname, 'lname': lname, 'rdvs': rdvs}
        
        return render(request, 'patient/Your_Appointments.html', context)
    
@login_required
def dtl_rdv(request,id):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif hasattr(request.user, 'patient'):
        
        name_user = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        rdv = RendezVous.objects.get(id=id)
        analyse = rdv.analyes
        conseilles = Conseille.objects.filter(conseilleanalyse__code_analyse__in=analyse.split('$'))
        analyses = analyse.split("$")
        labo = Branche.objects.get(id = rdv.branche.id)
        analyses_lab = PrixAnalyse.objects.filter(id_lab=labo.labo).select_related('code_analyse')
        name_analyses = TypeAnalyse.objects.filter(code__in=analyses)
        today = datetime.now().date()
        rdvs = RendezVous.objects.filter(branche=labo, date__gte=today)
        branch_rdv_details = [
            rdv.date.strftime("%Y-%m-%d") + ">" + rdv.heur.strftime("%H:%M")
            for rdv in rdvs
            ]
        print(branch_rdv_details)
        prix = 0
        print(analyses_lab[0].code_analyse.code)
        for name in name_analyses:
            for prix_analyse in name.prixanalyse_set.all():
                prix = prix + prix_analyse.prix
        if rdv.type_rdv == "domicile":
            prix = prix +50
            
        encryption_key = b'0jZopyHQyZUzgREXckBDsyyHqXDmhVPMtFqePm1wlCs='

        
        fernet = Fernet(encryption_key)
        base_url = request.build_absolute_uri('/')  # Get the base URL of the current page
        appointments_url = f"{base_url}appointments/" 
        encrypted_id = fernet.encrypt(str(id).encode()).decode()

        url = f'{appointments_url}{encrypted_id}/'

        # Create QR code instance
        qr_code = qrcode.QRCode(version=1, box_size=10, border=5)
        qr_code.add_data(url)
        qr_code.make(fit=True)
        qr_image = qr_code.make_image(fill='black', back_color='white')

        # Convert QR code image to Base64-encoded string
        buffered = BytesIO()
        qr_image.save(buffered, format='PNG')
        qr_image_base64 = base64.b64encode(buffered.getvalue()).decode('utf-8')

        context = {'name_user': name_user, 'fname':fname, 
                   'lname': lname, 'tel': request.user.get_num_telefone,
                   'rdv': rdv, 'name_analyses':name_analyses, 
                   'prix':prix, 'analyses_labs':analyses_lab, 'appointment':rdv, 
                   'qr_code_image_base64': qr_image_base64,'branch':labo, 
                   'rdv_booked':branch_rdv_details,
                   'conseilles':conseilles}
        if request.method == 'POST':
            
            form_name = request.POST.get('form_name')
            if form_name == 'deletrdv':
                if rdv.purpose == "blood test":
                    patient = Patient.objects.get(id = request.user.id)
                    if rdv.purpose != "blood donation":
                        annulation = Annulation.objects.create(
                            id_patient=patient,
                            branche=rdv.branche,
                            prix=float(prix) * 0.15, # calculate 85% of the total price
                            date=timezone.now()
                        )
                        annulation.save()
                        
                        payment = Payment.objects.get(rdv = id )
                        stripe.api_key = settings.STRIPE_SECRET_KEY

                        refund = stripe.Refund.create(
                            charge=payment.charge_id,
                            amount=int(payment.amount * Decimal('0.85')*100) # calculate 85% of the payment amount to refund
                        )
                    id_rdv = request.POST.get('id_rdv')
                    travail = TravailInfermier.objects.filter(id_rdv=id_rdv)
                    travail.delete()
                    rdv = RendezVous.objects.get(id=id_rdv)
                    rdv.delete()
                else:
                    id_rdv = request.POST.get('id_rdv')
                    travail = TravailInfermier.objects.filter(id_rdv=id_rdv)
                    travail.delete()
                    rdv = RendezVous.objects.get(id=id_rdv)
                    rdv.delete()
                return redirect('your_appointments')
            elif form_name == 'updaterdv':
                time = request.POST.get('time')
                date = request.POST.get('date')
                rdv.date = date
                rdv.heur = time
                rdv.save()
                return redirect('detaille_appointments', id=id)
        return render(request, 'patient/rdv_detaille.html', context)

def analyse_labo(request, id):
    labo = Branche.objects.get(id = id)
    analyse = PrixAnalyse.objects.filter(id_lab=labo.labo).values('code_analyse__code', 'code_analyse__nom')
    data = list(analyse)
    return JsonResponse(data, safe=False)


@login_required
def result(request):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif Employe.objects.filter(id_prs=request.user.id).exists():
        employe = Employe.objects.get(id_prs=request.user.id)
        if Infirmier.objects.filter(id=employe.id).exists():
            return redirect('homeinfirmier')
        elif MedecinChef.objects.filter(id=employe.id).exists():
            return redirect('homemedecinchef')
        elif Receptionniste.objects.filter(id=employe.id).exists():
            return redirect('homereceptionniste')
    elif hasattr(request.user, 'patient'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        with connection.cursor() as cursor:
            cursor.callproc("SearchResultPatient", [request.user.id])
            columns = [column[0] for column in cursor.description]
            result = [dict(zip(columns, row)) for row in cursor.fetchall()]
        context = {'name': name, 'fname':fname, 'lname': lname, 'results':result}
        return render(request, 'patient/Your_Resultat.html', context)

@login_required
def channels(request):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif Employe.objects.filter(id_prs=request.user.id).exists():
        employe = Employe.objects.get(id_prs=request.user.id)
        if Infirmier.objects.filter(id=employe.id).exists():
            return redirect('homeinfirmier')
        elif MedecinChef.objects.filter(id=employe.id).exists():
            return redirect('homemedecinchef')
        elif Receptionniste.objects.filter(id=employe.id).exists():
            return redirect('homereceptionniste')
    elif hasattr(request.user, 'patient'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        
        context = {'name': name, 'fname':fname, 'lname': lname,}
        return render(request, 'patient/channels.html', context)
    
    
def channels_data_view(request):
    
    mockChannels = []

    channels_data = Canaux.objects.filter(pat=request.user.id).values('id','branch')

    # Iterate over the channels data and populate the mockChannels list
    for channel_data in channels_data:
        branch = Branche.objects.get(id= channel_data['branch'])
        lab = Laboratoire.objects.get(id=branch.labo.id)
        channel = {
            "id": channel_data['id'],
            "name": lab.nom + " " + branch.branche_nom,
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
        if emetteur == "patient":
            channel['sender'] = True
        else:
            channel['sender'] = False
        mockChannels.append(channel)
    mockChannels = sorted(mockChannels, key=lambda x: datetime.strptime(x['latestMessage'], '%I:%M %p'), reverse=True)
    return JsonResponse(mockChannels, safe=False)


@login_required
def messages_pat(request,id):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif Employe.objects.filter(id_prs=request.user.id).exists():
        employe = Employe.objects.get(id_prs=request.user.id)
        if Infirmier.objects.filter(id=employe.id).exists():
            return redirect('homeinfirmier')
        elif MedecinChef.objects.filter(id=employe.id).exists():
            return redirect('homemedecinchef')
        elif Receptionniste.objects.filter(id=employe.id).exists():
            return redirect('homereceptionniste')
    elif hasattr(request.user, 'patient'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        
        channels = Canaux.objects.get(id= id)
        branch = Branche.objects.get(id= channels.branch.id)
        lab = Laboratoire.objects.get(id=branch.labo.id)
        name_channel = lab.nom + " " + branch.branche_nom 
        if request.method == 'POST':
            algeria_tz = pytz.timezone('Africa/Algiers')
            now = timezone.now().astimezone(algeria_tz)
            date_now =  now.strftime("%Y-%m-%d %H:%M:%S")
            message = request.POST.get('message')
            Communication.objects.create(
                emetteur = 'patient',
                message = message,
                date = date_now,
                canaux = channels
            )
            response_data = {'status': 'success'}
            return JsonResponse(response_data)
        context = {'name': name, 'fname':fname, 'lname': lname, 'id':id ,'name_channel':name_channel}
        return render(request, 'patient/messages.html', context)
    
    
    


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


        
        if channel_data['emetteur'] == "patient":
            channel['own'] = True
        else:
            channel['own'] = False
        mockChannels.append(channel)
    return JsonResponse(mockChannels, safe=False)

def get_conseille(request):
    try:
        data = json.loads(request.body)
        analyse_codes = data.get('analyse')
        conseilles = Conseille.objects.filter(conseilleanalyse__code_analyse__in=analyse_codes.split('$'))
        conseille_list = list(conseilles.values())  # Convert queryset to a list of dictionaries
        return JsonResponse(conseille_list, safe=False)  # Return the JSON response
    except json.JSONDecodeError:
        print("expect")
        

def get_prix(request):
    try:
        data = json.loads(request.body)
        analyse_codes = data.get('analyse').split('$')
        id_branch = data.get('branch')
        print(analyse_codes, id_branch)
        lab = Laboratoire.objects.get(branche__id=id_branch)

        # Retrieve the corresponding PrixAnalyse objects
        prix_analyse = PrixAnalyse.objects.filter(id_lab=lab, code_analyse__in=analyse_codes)

        # Retrieve the prices and names for the analyses
        prices = [pa.prix for pa in prix_analyse]
        names = [pa.code_analyse.nom for pa in prix_analyse]
        data = [{'name': name, 'price': price} for name, price in zip(names, prices)]
        return JsonResponse(data, safe=False)
    except json.JSONDecodeError:
        print("expect")



@login_required
def predection(request):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif Employe.objects.filter(id_prs=request.user.id).exists():
        employe = Employe.objects.get(id_prs=request.user.id)
        if Infirmier.objects.filter(id=employe.id).exists():
            return redirect('homeinfirmier')
        elif MedecinChef.objects.filter(id=employe.id).exists():
            return redirect('homemedecinchef')
        elif Receptionniste.objects.filter(id=employe.id).exists():
            return redirect('homereceptionniste')
    elif hasattr(request.user, 'patient'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()        
        age = request.user.get_date_birth()
        age = calculate_age(age)
        sex = request.user.get_sex()
        if sex == 'homme':
            sex = 0
        else:
            sex = 1
        if request.method == 'POST':
            form_name = request.POST.get('form_name')
            print(form_name)
            if form_name == 'diabet':
                preg = request.POST.get('preg')
                gluco = request.POST.get('gluco')
                bp = request.POST.get('bp')
                stinmm = request.POST.get('stinmm')
                insulin = request.POST.get('insulin')
                mass = request.POST.get('mass')
                dpf = request.POST.get('dpf')
                print(preg,gluco,bp,stinmm,insulin,mass,dpf)
                ['preg', 'gluco', 'bp', 'stinmm', 'insulin', 'mass', 'dpf', 'age']
                input_data = np.array([preg, gluco, bp, stinmm, insulin, mass, dpf, age])  # single patient's readings
                feature_names, importances ,percentage= prediction_dibaset(input_data)
                predection = prediction_diabet(percentage,feature_names)
                importances_str = '[' + ', '.join([str(val) for val in importances]) + ']'
                feature_names_str = '[' + ', '.join(['"{0}"'.format(name) for name in feature_names]) + ']'
                recomondation = recomondation_diabet(percentage)
                recomondation = recomondation.split('\n')
                context = {'name': name, 'fname':fname, 'lname': lname,'percentage':percentage, 'feature_names':feature_names_str, 'importances':importances_str, 'predection':predection,'recomondations':recomondation }
                return render(request, 'patient/predection_static.html', context)
            elif form_name == 'anemia':
                rbc = request.POST.get('rbc')
                pcv = request.POST.get('pcv')
                mcv = request.POST.get('mcv')
                mch = request.POST.get('mch')
                mchc = request.POST.get('mchc')
                rdw = request.POST.get('rdw')
                tlc = request.POST.get('tlc')
                plt = request.POST.get('plt')
                hgb = request.POST.get('hgb')
                input_data = np.array([age, sex,rbc,pcv,mcv,mch,mchc,rdw,tlc,plt,hgb])  # Single patient's readings
                feature_names, importances ,percentage= prediction_anemia(input_data)
                predection = prediction_Anemia(percentage,feature_names)
                importances_str = '[' + ', '.join([str(val) for val in importances]) + ']'
                feature_names_str = '[' + ', '.join(['"{0}"'.format(name) for name in feature_names]) + ']'
                recomondation = recomondation_Anemia(percentage)
                recomondation = recomondation.split('\n')
                context = {'name': name, 'fname':fname, 'lname': lname,'percentage':percentage, 'feature_names':feature_names_str, 'importances':importances_str, 'predection':predection,'recomondations':recomondation }
                return render(request, 'patient/predection_static.html', context)
            elif form_name == 'heart':
                cp = request.POST.get('cp')
                trestbps = request.POST.get('trestbps')
                chol = request.POST.get('chol')
                fbs = request.POST.get('fbs')
                restecg = request.POST.get('restecg')
                thalach = request.POST.get('thalach')
                exang = request.POST.get('exang')
                oldpeak = request.POST.get('oldpeak')
                slope = request.POST.get('slope')
                ca = request.POST.get('ca')
                thal = request.POST.get('thal')
                input_data = np.array([age, sex, cp, trestbps, chol, fbs, restecg, thalach, exang, oldpeak, slope, ca, thal])  # Replace with your actual input
                percentage, feature_names, importances = heart_prediction(input_data)
                predection = prediction_Heart(percentage,feature_names)
                importances_str = '[' + ', '.join([str(val) for val in importances]) + ']'
                feature_names_str = '[' + ', '.join(['"{0}"'.format(name) for name in feature_names]) + ']'
                recomondation = recomondation_Heart(percentage)
                recomondation = recomondation.split('\n')
                context = {'name': name, 'fname':fname, 'lname': lname,'percentage':percentage, 'feature_names':feature_names_str, 'importances':importances_str, 'predection':predection,'recomondations':recomondation }
                return render(request, 'patient/predection_static.html', context)
            elif form_name == 'liver':
                total_bilirubin = request.POST.get('total_bilirubin')
                direct_bilirubin = request.POST.get('direct_bilirubin')
                alkaline_phosphatase = request.POST.get('alkaline_phosphatase')
                alamine_aminotransferase = request.POST.get('alamine_aminotransferase')
                aspartate_aminotransferase = request.POST.get('aspartate_aminotransferase')
                total_proteins = request.POST.get('total_proteins')
                albumin = request.POST.get('albumin')
                albumin_globulin_ratio = request.POST.get('albumin_globulin_ratio')
                input_data = np.array([age, sex, total_bilirubin,
                                       direct_bilirubin, alkaline_phosphatase, alamine_aminotransferase,
                                       aspartate_aminotransferase, total_proteins, albumin, albumin_globulin_ratio])  # single patient's readings
                feature_names, importances, percentage = prediction_liver(input_data)
                predection = prediction_Liver(percentage,feature_names)
                importances_str = '[' + ', '.join([str(val) for val in importances]) + ']'
                feature_names_str = '[' + ', '.join(['"{0}"'.format(name) for name in feature_names]) + ']'
                recomondation = recomondation_Liver(percentage)
                recomondation = recomondation.split('\n')
                context = {'name': name, 'fname':fname, 'lname': lname,'percentage':percentage, 'feature_names':feature_names_str, 'importances':importances_str, 'predection':predection,'recomondations':recomondation }
                return render(request, 'patient/predection_static.html', context)
        context = {'name': name, 'fname':fname, 'lname': lname, }
        return render(request, 'patient/predection.html', context)        
        
@login_required
def notification_patient(request):
    if hasattr(request.user, 'directeur'):
        return redirect('homedirecteur')
    elif Employe.objects.filter(id_prs=request.user.id).exists():
        employe = Employe.objects.get(id_prs=request.user.id)
        if Infirmier.objects.filter(id=employe.id).exists():
            return redirect('homeinfirmier')
        elif MedecinChef.objects.filter(id=employe.id).exists():
            return redirect('homemedecinchef')
        elif Receptionniste.objects.filter(id=employe.id).exists():
            return redirect('homereceptionniste')
    elif hasattr(request.user, 'patient'):
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
            return redirect('notification_patient')
        context = {'name': name, 'fname':fname, 'lname': lname,'notifications' : notifications}
        return render(request,"patient/notification.html",context)

        
def signout(request):
    logout(request)
    messages.success(request, 'You have successfully logged out.')
    return redirect('/')

