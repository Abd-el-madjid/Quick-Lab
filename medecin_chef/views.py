from django.shortcuts import render
import json
import os
from django.utils import timezone   
from django.contrib.auth import update_session_auth_hash

from django.shortcuts import redirect, render
from django.contrib.auth.decorators import login_required
from django.core.mail import send_mail
import numpy as np
from quick_lab import settings
from login.models import Employe, Infirmier, MedecinChef, Patient, Personne, Receptionniste
from patient.models import RendezVous, TravailInfermier
from directeur.models import Branche, PrixAnalyse, TypeAnalyse, Laboratoire
from accueill.models import Notification
from datetime import date, datetime, timedelta
from django.db import connection
from django.http import JsonResponse, HttpResponse
from barcode.writer import ImageWriter
from django.contrib import messages
from django.contrib.auth import logout
from django.utils import timezone
import pytz
from infirmier.models import CanauxEmp, Discussion, Resultat, TubeAnalyse
from .bakends import prediction
from receptionniste.backends import calculate_age
from .models import PocheSang, Rapport, ResultatRapportPdf
from barcode import Code39
from django.template.loader import get_template
import subprocess
from django.core.mail import EmailMessage

@login_required
def homeinfirmier(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
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
                context = {'name': name, 'fname':fname, 'lname': lname}
                return render(request, 'medecin_chef/homeMedcin_chef.html', context)
            
            
@login_required
def results(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                branch_id = Employe.objects.get(id_prs=user.id).id_branche_id

                with connection.cursor() as cursor:
                    # Call the stored procedure with the parameter
                    cursor.execute("CALL SelectResultsByBranchId_blood_test(%s)", [branch_id])

                    # Fetch the results
                    columns = [column[0] for column in cursor.description]
                    results = [dict(zip(columns, row)) for row in cursor.fetchall()]
                with connection.cursor() as cursor:
                    # Call the stored procedure with the parameter
                    cursor.execute("CALL SelectResultsByBranchId_blood_donation(%s)", [branch_id])

                    # Fetch the results
                    columns = [column[0] for column in cursor.description]
                    donations = [dict(zip(columns, row)) for row in cursor.fetchall()]
                
                context = {'name': name, 'fname':fname, 'lname': lname, 'results':results, 'donations':donations}
                return render(request, 'medecin_chef/Results.html', context)
            
            
@login_required
def rapport(request, id):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                percentage = None
                feature_names_str = None
                importances_str = None
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                rapport_bd = Rapport.objects.filter(id=id).first()
                
                tube_id = Resultat.objects.get(id=id).tube
                code_analyse = TubeAnalyse.objects.get(id=tube_id.id).code_analyse
                analyse_name = TypeAnalyse.objects.get(code = code_analyse.code).nom
                feature_names = None
                importances = None
                percentage = None
                
                
                results = Resultat.objects.get(id=id).resultat
                results = results.split('$')
                result = []
                for data in results:
                    parts = data.strip().split('>')
                    if len(parts) >= 3:
                        result.append({
                            'title': parts[0].strip(),
                            'value': parts[1].strip(),
                            'unit': parts[2].strip()
                        })
                
                if analyse_name in ['anemia analysis', 'liver analysis', 'diabetes analysis']:
                    if analyse_name == 'diabetes analysis':
                        results = Resultat.objects.get(id=id).resultat
                        results = results.split('$')
                        result_val = []
                        for data in results:
                            parts = data.strip().split('>')
                            if len(parts) >= 3:
                                result_val.append(parts[1].strip())
                        age = Personne.objects.get(id = (Patient.objects.get(id = (RendezVous.objects.get(id = (TubeAnalyse.objects.get(id = tube_id.id)).rdv.id).id_patient.id)).id.id)).date_naissance
                        age = calculate_age(age)
                        result_val.append(age)
                        result_array = np.array(result_val)
                        print(result_array)
                    elif analyse_name == 'anemia analysis':
                        result_val = []
                        patient =Personne.objects.get(id = (Patient.objects.get(id = (RendezVous.objects.get(id = (TubeAnalyse.objects.get(id = tube_id.id)).rdv.id).id_patient.id)).id.id))
                        age = patient.date_naissance
                        age = calculate_age(age)
                        result_val.append(age)
                        sex = patient.sex
                        if sex == 'homme':
                            sex = 0
                        else:
                            sex = 1
                        result_val.append(sex)
                        results = Resultat.objects.get(id=id).resultat
                        results = results.split('$')
                        
                        for data in results:
                            parts = data.strip().split('>')
                            if len(parts) >= 3:
                                result_val.append(parts[1].strip())
                        result_array = np.array(result_val)
                        print(result_array)
                    elif analyse_name == 'liver analysis':
                        result_val = []
                        patient =Personne.objects.get(id = (Patient.objects.get(id = (RendezVous.objects.get(id = (TubeAnalyse.objects.get(id = tube_id.id)).rdv.id).id_patient.id)).id.id))
                        age = patient.date_naissance
                        age = calculate_age(age)
                        result_val.append(age)
                        sex = patient.sex
                        if sex == 'homme':
                            sex = 0
                        else:
                            sex = 1
                        result_val.append(sex)
                        results = Resultat.objects.get(id=id).resultat
                        results = results.split('$')
                        for data in results:
                            parts = data.strip().split('>')
                            if len(parts) >= 3:
                                result_val.append(parts[1].strip())
                        result_array = np.array(result_val)
                        print(result_array)

                    feature_names, importances, percentage,rapport = prediction(analyse_name,result_array)
                    print(feature_names, importances, percentage,rapport)
                    importances_str = '[' + ', '.join([str(val) for val in importances]) + ']'
                    feature_names_str = '[' + ', '.join(['"{0}"'.format(name) for name in feature_names]) + ']'
                    if Rapport.objects.filter(id=id) :
                        rp = Rapport.objects.get(id=id)
                        rp.rapport=rapport
                        rp.save()
                    else:
                        results = Resultat.objects.get(id=id)
                        med = MedecinChef.objects.get(id=employe.id)
                        Rapport.objects.create(
                            id= id,
                            med= med,
                            rapport = rapport,
                            resultat = results,
                            is_validate = False,
                        )
                        
                else:
                    if not Rapport.objects.filter(id=id).exists():
                        
                        results = Resultat.objects.get(id=id)
                        med = MedecinChef.objects.get(id=employe.id)
                        Rapport.objects.create(
                            id= id,
                            med= med,
                            rapport = None,
                            resultat = results,
                            is_validate = False,
                        )   
                    
                if request.method == 'POST':
                    rapport_bd = Rapport.objects.get(id=id)
                    rapport_bd.is_validate = True
                    rapport_bd.save()
                    
                    branche = Branche.objects.get(id = Employe.objects.get(id_prs=user.id).id_branche.id)
                    labo = Laboratoire.objects.get(id = branche.labo.id)
                    patient = Personne.objects.get(id = (Patient.objects.get(id = (RendezVous.objects.get(id = (TubeAnalyse.objects.get(id = tube_id.id)).rdv.id).id_patient.id)).id.id))
                    algeria_tz = pytz.timezone('Africa/Algiers')
                    now = timezone.now().astimezone(algeria_tz)
                    id_resultat = str(branche.id) + "_" + now.strftime("%Y%m%d_%H%M%S")
                    id_resultat = id_resultat.replace("_", "")
                    rdv = RendezVous.objects.get(id = (TubeAnalyse.objects.get(id = tube_id.id)).rdv.id)
                    date = timezone.now().date()
                    
                    #creating bare code
                    barcode_value = str(id_resultat)
                    barcode = Code39(barcode_value, writer=ImageWriter())
                    barcode_file_path = os.path.join('media', 'barcode_result', '{}'.format(id_resultat))
                    barcode.save(barcode_file_path)
                    
                    barcode_file_path = barcode_file_path +".png"
                    print(barcode_file_path)
                    
                    # send data to template
                    data_result = {
                        'Laboratory': {'labo_name': labo.nom},
                        'branch': {'id':branche.id , 'localisation': branche.localisation, 'tel':branche.num_telephone, 'email':branche.email},
                        'patient': {'id': patient.id , 'prenom': patient.prenom, 'date':patient.date_naissance, 'age':calculate_age(patient.date_naissance), 'sex':patient.sex, 'email': request.user.email},
                        'resultat': {'id': id_resultat, 'rdv_date': rdv.date, 'rdv_heur': rdv.heur, 'date': date},
                        'analyse': {'code': code_analyse, 'result': result, 'name':analyse_name},
                        'rapport': rapport_bd.rapport,
                        'barcode_image': barcode_file_path,
                    }
                    
    
                    
                    #creating resultat_pdf
                    template = get_template('medecin_chef/result.html')
                    html_string = template.render(data_result)
                    filename = 'result-{}.pdf'.format(id_resultat)
                    output_dir = os.path.join('pdf', 'result')
                    os.makedirs(output_dir, exist_ok=True)
                    file_path = os.path.join(output_dir, filename)
                    command = ['wkhtmltopdf', '-', file_path]
                    
                        # Assuming `html_string` contains the HTML content for the invoice
                    try:
                        html_bytes = html_string.encode('utf-8')  # Encode html_string as bytes
                        subprocess.run(command, input=html_bytes, check=True)
                        results_rap = Resultat.objects.get(id=id)
                        ResultatRapportPdf.objects.create(
                            id = id_resultat,
                            chemin = file_path,
                            id_resultat = results_rap,
                            id_rapport = rapport_bd,
                        )
                        subject = 'result'
                        message = f'Hi Patient, Please find attached your result for the medical services provided.'

                        email = EmailMessage(
                            subject=subject,
                            body=message,
                            from_email=settings.EMAIL_HOST_USER,
                            to=[patient.email],
                            attachments=[(filename, open(file_path, 'rb').read(), 'application/pdf')],
                        )
                        email.send()
                        response_data = {'status': 'success'}
                    except subprocess.CalledProcessError as e:
                        print('Error generating PDF:', e)
                    
                    
                                     
                    
                    return JsonResponse(response_data)
            context = {'name': name, 'fname':fname, 'lname': lname, "analyse_name":analyse_name,
                       "results":result, "id":id, 'rapport': rapport_bd.rapport if rapport_bd else None,
                       'feature_names_str':feature_names_str, 'importances_str':importances_str, 'percentage':percentage}
            return render(request, 'medecin_chef/resultat_detaille.html', context)
            
@login_required
def edit_rapport(request, id):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                rapport_bd = Rapport.objects.filter(id=id).first()
                if request.method == 'POST':
                    rapport = request.POST.get('message')
                    med = MedecinChef.objects.get(id=employe.id)
                    results = Resultat.objects.get(id=id)
                    if rapport_bd is not None:
                        rapport_bd = Rapport.objects.get(id=id)
                        rapport_bd.rapport = rapport
                        rapport_bd.save()
                    else:
                        Rapport.objects.create(
                            id= id,
                            med= med,
                            rapport = rapport,
                            resultat = results,
                            is_validate = False,
                        )                  
                    response_data = {'status': 'success'}
                    return JsonResponse(response_data)
                context = {'name': name, 'fname':fname, 'lname': lname, "id":id, 'rapport': rapport_bd.rapport if rapport_bd else None }
                return render(request, 'medecin_chef/resultat_detaille_edit.html', context)

@login_required
def rapport_donation(request, id):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                tube = TubeAnalyse.objects.filter(rdv=id)
                results = Resultat.objects.filter(tube__in = tube)
                processed_results = []
                
                for result in results:
                    # Process the 'resultat' field
                    items = []
                    tube_results = result.resultat.split('$')
                    for data in tube_results:
                        parts = data.strip().split('>')
                        if len(parts) >= 3:
                            items.append({
                                'title': parts[0].strip(),
                                'value': parts[1].strip(),
                                'unit': parts[2].strip(),
                            })

                    # Retrieve the analyse_name for the first TubeAnalyse object
                    tube = result.tube
                    code_analyse = tube.code_analyse
                    analyse_name = TypeAnalyse.objects.get(code=code_analyse.code).nom
                    rapport = Rapport.objects.filter(resultat_id=result).first()
                    if rapport is None:
                        med = MedecinChef.objects.get(id=employe.id)
                        Rapport.objects.create(
                            id= result.id,
                            med= med,
                            rapport = None,
                            resultat = result,
                            is_validate = False,
                        )
                        rapport = Rapport.objects.get(resultat_id=result)
                    # Append the processed result to the list
                    processed_results.append({
                        'id_result': result.id,
                        'rapport': rapport.rapport,
                        'analyse_name': analyse_name,
                        'items': items,
                        'code_analyse':code_analyse.code
                    })
                
                if request.method == 'POST':
                    etat = request.POST.get('etat')
                    tube = TubeAnalyse.objects.filter(rdv=id)
                    results = Resultat.objects.filter(tube__in = tube)
                    poche_sang = PocheSang.objects.get(id_rdv=id)
                    for result in results:
                        rapport_bd = Rapport.objects.get(id=result.id)
                        rapport_bd.is_validate = True
                        rapport_bd.save()
                    if etat == "valid":
                        poche_sang.is_accepted = True
                        poche_sang.save()
                    else:
                        poche_sang.is_accepted = False
                        poche_sang.save()
                    for result in results:
                        branche = Branche.objects.get(id = Employe.objects.get(id_prs=user.id).id_branche.id)
                        labo = Laboratoire.objects.get(id = branche.labo.id)
                        code_analyse = TubeAnalyse.objects.get(id=result.tube_id).code_analyse
                        analyse_name = TypeAnalyse.objects.get(code = code_analyse.code).nom
                        patient = Personne.objects.get(id = (Patient.objects.get(id = (RendezVous.objects.get(id = id).id_patient.id)).id.id))
                        results_don = result.resultat.split('$')
                        result_don = []
                        for data in results_don:
                            parts = data.strip().split('>')
                            if len(parts) >= 3:
                                result_don.append({
                                    'title': parts[0].strip(),
                                    'value': parts[1].strip(),
                                    'unit': parts[2].strip()
                                })
                        rapport_bd = Rapport.objects.get(id=result.id)
                        algeria_tz = pytz.timezone('Africa/Algiers')
                        now = timezone.now().astimezone(algeria_tz)
                        id_resultat = str(branche.id) + "_" + now.strftime("%Y%m%d_%H%M%S")
                        id_resultat = id_resultat.replace("_", "")
                        rdv = RendezVous.objects.get(id = id)
                        date = timezone.now().date()
                        
                        #creating bare code
                        barcode_value = str(id_resultat)
                        barcode = Code39(barcode_value, writer=ImageWriter())
                        barcode_file_path = os.path.join('media', 'barcode_result', '{}'.format(id_resultat))
                        barcode.save(barcode_file_path)
                        
                        barcode_file_path = barcode_file_path +".png"
                        print(barcode_file_path)
                        
                        # send data to template
                        data_result = {
                            'Laboratory': {'labo_name': labo.nom},
                            'branch': {'id':branche.id , 'localisation': branche.localisation, 'tel':branche.num_telephone, 'email':branche.email},
                            'patient': {'id': patient.id , 'prenom': patient.prenom, 'date':patient.date_naissance, 'age':calculate_age(patient.date_naissance), 'sex':patient.sex, 'email': request.user.email},
                            'resultat': {'id': id_resultat, 'rdv_date': rdv.date, 'rdv_heur': rdv.heur, 'date': date},
                            'analyse': {'code': code_analyse, 'result': result_don, 'name':analyse_name},
                            'rapport': rapport_bd.rapport,
                            'barcode_image': barcode_file_path,
                        }
                        
        
                        
                        #creating resultat_pdf
                        template = get_template('medecin_chef/result.html')
                        html_string = template.render(data_result)
                        filename = 'result-{}.pdf'.format(id_resultat)
                        output_dir = os.path.join('pdf', 'result')
                        os.makedirs(output_dir, exist_ok=True)
                        file_path = os.path.join(output_dir, filename)
                        command = ['wkhtmltopdf', '-', file_path]
                        
                            # Assuming `html_string` contains the HTML content for the invoice
                        try:
                            html_bytes = html_string.encode('utf-8')  # Encode html_string as bytes
                            subprocess.run(command, input=html_bytes, check=True)
                            
                            ResultatRapportPdf.objects.create(
                                id = id_resultat,
                                chemin = file_path,
                                id_resultat = result,
                                id_rapport = rapport_bd,
                            )
                            subject = 'result'
                            message = f'Hi Patient, Please find attached your result for the medical services provided.'

                            email = EmailMessage(
                                subject=subject,
                                body=message,
                                from_email=settings.EMAIL_HOST_USER,
                                to=[patient.email],
                                attachments=[(filename, open(file_path, 'rb').read(), 'application/pdf')],
                            )
                            email.send()
                            response_data = {'status': 'success'}
                        except subprocess.CalledProcessError as e:
                            print('Error generating PDF:', e)
                    
                    
                                     
                    
                    return JsonResponse(response_data)
                context = {'name': name, 'fname':fname, 'lname': lname, 'results': processed_results,'id':id,}
                return render(request, 'medecin_chef/resultat_detaille_don.html', context)


@login_required
def edit_rapport_don(request, id):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                rapport_bd = Rapport.objects.filter(id=id).first()
                rdv = TubeAnalyse.objects.get(id = (Resultat.objects.get(id = id)).tube.id)
                id_rdv = rdv.rdv.id
                if request.method == 'POST':
                    rapport = request.POST.get('message')
                    med = MedecinChef.objects.get(id=employe.id)
                    results = Resultat.objects.get(id=id)
                    if rapport_bd is not None:
                        rapport_bd = Rapport.objects.get(id=id)
                        rapport_bd.rapport = rapport
                        rapport_bd.save()
                    else:
                        Rapport.objects.create(
                            id= id,
                            med= med,
                            rapport = rapport,
                            resultat = results,
                            is_validate = False,
                        )                  
                    response_data = {'status': 'success'}
                    return JsonResponse(response_data)
                context = {'name': name, 'fname':fname, 'lname': lname, "id":id, "id_rdv":id_rdv, 'rapport': rapport_bd.rapport if rapport_bd else None }
                return render(request, 'medecin_chef/resultat_detaille_edit_don.html', context)


@login_required
def channels(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                context = {'name': name, 'fname':fname, 'lname': lname,}
                return render(request, 'medecin_chef/channels.html', context)
    
    
def channels_data_view(request):
    employe = Employe.objects.get(id_prs=request.user.id)
    med = MedecinChef.objects.get(id = employe.id)
    mockChannels = []
    
    channels_data = CanauxEmp.objects.filter(id_med=med.id.id).values('id','id_med','id_inf')
    print(channels_data)
    # Iterate over the channels data and populate the mockChannels list
    for channel_data in channels_data:
        
        channel = {
            "id": channel_data['id'],
            "name": Personne.objects.get(id = Employe.objects.get(id=channel_data['id_inf']).id_prs.id ).prenom +" " +Personne.objects.get(id = Employe.objects.get(id=channel_data['id_inf']).id_prs.id ).nom ,
            "favorite": False,
            "sender": True,
            "messages": "",
            "latestMessage": "01:00 AM"  # Initialize as empty string
        }

        # Retrieve the latest message for the current channel
        if Discussion.objects.filter().first() is not None:
            latest_date = Discussion.objects.filter(id_canaux=channel_data['id']).order_by('-date').values_list('date', flat=True).first()
            latest_date += timedelta(hours=1)
            if latest_date:
                channel['latestMessage'] = latest_date.strftime('%I:%M %p')

        # Append the channel to the mockChannels list
        
            emetteur = Discussion.objects.filter(id_canaux=channel_data['id']).values_list('emetteur', flat=True).last()
            if emetteur == "infirmier":
                channel['sender'] = False
            else:
                channel['sender'] = True
        mockChannels.append(channel)
    mockChannels = sorted(mockChannels, key=lambda x: datetime.strptime(x['latestMessage'], '%I:%M %p'), reverse=True)
    return JsonResponse(mockChannels, safe=False)


@login_required
def messages_pat(request,id):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                channels = CanauxEmp.objects.get(id= id)
                
                name_channel = Personne.objects.get(id = Employe.objects.get(id=channels.id_inf.id.id).id_prs.id ).prenom + " " + Personne.objects.get(id = Employe.objects.get(id=channels.id_inf.id.id).id_prs.id ).nom 
                if request.method == 'POST':
                    algeria_tz = pytz.timezone('Africa/Algiers')
                    now = timezone.now().astimezone(algeria_tz)
                    date_now =  now.strftime("%Y-%m-%d %H:%M:%S")
                    message = request.POST.get('message')
                    Discussion.objects.create(
                        emetteur = 'medcin_chef',
                        message = message,
                        date = date_now,
                        id_canaux = channels
                    )
                    response_data = {'status': 'success'}
                    return JsonResponse(response_data)
                context = {'name': name, 'fname':fname, 'lname': lname, 'id':id ,'name_channel':name_channel}
                return render(request, 'medecin_chef/messages.html', context)
    
    
    


def messages_data(request,id):
    
    mockChannels = []

    channels_data = Discussion.objects.filter(id_canaux=id).values('emetteur','message','date')
    # Iterate over the channels data and populate the mockChannels list
    for channel_data in channels_data:
        
        channel = {

            "createdOn": channel_data['date'],
            "channel": id,
            "own": False,
            "text": channel_data['message'],
            
        }


        
        if channel_data['emetteur'] == "medcin_chef":
            channel['own'] = True
        else:
            channel['own'] = False
        mockChannels.append(channel)
    return JsonResponse(mockChannels, safe=False)


@login_required
def notification_medecin(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
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
                    return redirect('notification_medecin')
                # Print the results
                context = {'name': name, 'fname':fname, 'lname': lname,'notifications' : notifications}
                return render(request, 'medecin_chef/notification.html', context)


@login_required
def account_medecin(request):
    if request.user.is_authenticated:
        user = request.user
        if hasattr(user, 'patient'):
            return redirect('homepatient')
        elif hasattr(user, 'directeur'):
            return redirect('homedirecteur')
        elif Employe.objects.filter(id_prs=user.id).exists():
            employe = Employe.objects.get(id_prs=user.id)
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif Infirmier.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
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
                        if not request.user.check_password(password):
                            messages.error(request, 'Incorrect password. Please try again.')
                            return redirect('account_medecin')
                        request.user.email = email
                        request.user.num_telephone = num_telephone
                        request.user.save()
                        print("im here5")
                        update_session_auth_hash(request, request.user)
                        return redirect('account_medecin')
                    elif form_name == 'changepassword':
                        current_password = request.POST.get('currentPassword')
                        new_password = request.POST.get('newPassword')
                        new_password_confirm = request.POST.get('newPasswordConfirm')

                        if not request.user.check_password(current_password):
                            messages.error(request, 'The current password you entered is incorrect.')
                            return redirect('account_medecin')

                        if new_password != new_password_confirm:
                            messages.error(request, 'The new passwords you entered do not match.')
                            return redirect('account_medecin')

                        request.user.set_password(new_password)
                        request.user.save()
                        update_session_auth_hash(request, request.user)
                        messages.success(request, 'Your password has been changed successfully.')
                        return redirect('account_medecin')
                    elif form_name == 'deletacount':
                        request.user.is_active = False
                        request.user.save()
                        logout(request)
                        return redirect('account_medecin')
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
                        return redirect('account_medecin')
                return render(request, 'medecin_chef/account.html', context)

                                    
@login_required
def signout(request):
    logout(request)
    messages.success(request, 'You have successfully logged out.')
    return redirect('/')