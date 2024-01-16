from datetime import datetime, timedelta
from django.utils import timezone   
import json
import os
from django.shortcuts import redirect, render
from django.contrib.auth.decorators import login_required
from django.core.mail import send_mail
import pytz
from quick_lab import settings
from login.models import Employe, Infirmier, MedecinChef, Patient, Personne, Receptionniste
from patient.models import RendezVous, TravailInfermier
from directeur.models import Branche, PrixAnalyse, TypeAnalyse
from directeur.backend import generate_password, generate_username
from datetime import date
from django.db.models import F, Q
from django.db import connection
from django.http import JsonResponse, HttpResponse
import barcode
from barcode.writer import ImageWriter
from django.contrib import messages
from django.contrib.auth import logout
from accueill.models import Notification

from medecin_chef.models import PocheSang
from django.contrib.auth import update_session_auth_hash
from django.core.mail import EmailMessage

from .models import AnalyseChamp, CanauxEmp, Discussion, Resultat, TubeAnalyse


# Create your views here.

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
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Infirmier.objects.filter(id=employe.id).exists():
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
                return render(request, 'infirmier/homeInfirmier.html', context)
            
            
@login_required            
def appointment_liste(request):
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
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Infirmier.objects.filter(id=employe.id).exists():
            
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                


                infermier_id = Employe.objects.get(id_prs=user.id).id

                with connection.cursor() as cursor:
                    # Call the stored procedure with the parameter
                    cursor.execute("CALL GetAppointmentsByInfermierId(%s)", [infermier_id])

                    # Fetch the results
                    columns = [column[0] for column in cursor.description]
                    appointments = [dict(zip(columns, row)) for row in cursor.fetchall()]
                    # appointments = cursor.fetchall()

                with connection.cursor() as cursor:
                    # Call the stored procedure with the parameter
                    cursor.execute("CALL GetAppointmentsFinishByInfermierId(%s)", [infermier_id])

                    columns = [column[0] for column in cursor.description]
                    appointmentsFinish = [dict(zip(columns, row)) for row in cursor.fetchall()]

                context = {'name': name, 'fname':fname, 'lname': lname, 'appointments':appointments, 'appointmentsFinish':appointmentsFinish}

                return render(request, 'infirmier/Appointmentslist.html', context)
            
@login_required            
def Appointment_detaille(request,id):
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
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Infirmier.objects.filter(id=employe.id).exists():
            
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                


                infermier_id = Employe.objects.get(id_prs=user.id).id
                Appointment_detaille = RendezVous.objects.get(id=id)
                
                patient = Personne.objects.get(id= (Patient.objects.get(id= Appointment_detaille.id_patient.id)).id.id)
                analyse = Appointment_detaille.analyes
                analyses = analyse.split("$")
                analyses = TypeAnalyse.objects.filter(code__in=analyses)
                
                context = {'name': name, 'fname':fname, 'lname': lname, 'Appointment_detaille':Appointment_detaille, 'patient':patient, 'analyses':analyses, 'infermier_id':infermier_id}
                if request.method == 'POST':
                    quantity = request.POST.get("quantity")
                    PocheSang.objects.create(
                        quantite_ml = quantity,
                        id_rdv = Appointment_detaille,
                        is_accepted = False
                    )
                    with connection.cursor() as cursor:
                        cursor.execute("CALL update_travail_infermier(%s)", [id])
                    return redirect('liste_appointments') 
                return render(request, 'infirmier/Appointment_detaille.html', context)
            
def add_tube_analyse(request):
    infermier_id = request.GET.get('nurse_id')
    rdv_id = request.GET.get('rdv_id')
    analyse_code = request.GET.get('analyse_code')
    print(analyse_code)
    current_time = datetime.now().strftime("%H:%M:%S")  # Get the current time
    barcode_value = f"{infermier_id}-{rdv_id}-{current_time}"

    valid_chars = "0123456789"
    barcode_value = ''.join(char for char in barcode_value if char in valid_chars)
    type_analyse = TypeAnalyse.objects.get(code=analyse_code)
    infirmier = Infirmier.objects.get(id=infermier_id)
    rdv = RendezVous.objects.get(id=rdv_id)    
    TubeAnalyse.objects.create(
        id = barcode_value,
        code_analyse = type_analyse,
        infirmier = infirmier,
        rdv = rdv,
        is_done = False,
    )
    
    barcode_class = barcode.codex.Code39
    barcode_image = barcode_class(barcode_value, writer=ImageWriter())
    directory_path = os.path.join('media', 'tube')
    file_name = f"{barcode_value}"
    file_path = os.path.join(directory_path, file_name)

    # Create the directory if it doesn't exist
    os.makedirs(directory_path, exist_ok=True)

    # Save the barcode image to the file path
    barcode_image.save(file_path, options={'png': {'write_text': False}})

    # Prepare the HTTP response
    response = HttpResponse(content_type='image/png')
    response['Content-Disposition'] = f'inline; filename="{file_name}.png"'
    file_path = os.path.join(directory_path, f"{file_name}.png")
    # Read the barcode image data and write it to the response
    with open(file_path, 'rb') as image_file:
        response.write(image_file.read())

    return response




def done_analyse(request):
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))
        rdv_id = data.get('rdv_id')
        with connection.cursor() as cursor:
            cursor.execute("CALL update_travail_infermier(%s)", [rdv_id])
        return JsonResponse({'message': 'Success'})


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
            if Receptionniste.objects.filter(id=employe.id).exists():
                return redirect('homereceptionniste')
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Infirmier.objects.filter(id=employe.id).exists():
            
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                infermier_id = Employe.objects.get(id_prs=user.id).id

                with connection.cursor() as cursor:
                    # Call the stored procedure with the parameter
                    cursor.execute("CALL get_results(%s)", [infermier_id])

                    # Fetch the results
                    columns = [column[0] for column in cursor.description]
                    results = [dict(zip(columns, row)) for row in cursor.fetchall()]
                context = {'name': name, 'fname':fname, 'lname': lname, 'results':results}
                return render(request, 'infirmier/Results.html', context)
            
            
def fill_result(request,id):
    name = request.user.get_full_name()
    fname = request.user.get_first_name()
    lname = request.user.get_last_name()
    code_analyse = TubeAnalyse.objects.get(id=id).code_analyse
    
    analyse_champ = AnalyseChamp.objects.get(code=code_analyse)
    champ_names = analyse_champ.champ_name.split('$')
    units = analyse_champ.units.split('$')
    context = {'name': name, 'fname':fname, 'lname': lname, 'champ_units': zip(champ_names, units)}
    
    
    if request.method == 'POST':
        tube_analyse = TubeAnalyse.objects.get(id=id)
        analyse_champ = AnalyseChamp.objects.get(code=tube_analyse.code_analyse)
        champ_names = analyse_champ.champ_name.split('$')
        units = analyse_champ.units.split('$')
        print(len(champ_names) ,len(units))
        result_str = ""
        if len(champ_names) == len(units):
            for champ_name, unit in zip(champ_names, units):
                value = request.POST.get(champ_name)
                print(value)
                result_str += f"{champ_name} > {value} > {unit}$"

            print(result_str)
            Resultat.objects.create(resultat=result_str, tube=tube_analyse)
            tube_analyse.is_done = True
            tube_analyse.save()
        return redirect('results_inf') 
    return render(request, 'infirmier/entre_resultat.html', context)    


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
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Infirmier.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                context = {'name': name, 'fname':fname, 'lname': lname,}
                return render(request, 'infirmier/channels.html', context)
    
    
def channels_data_view(request):
    employe = Employe.objects.get(id_prs=request.user.id)
    inf = Infirmier.objects.get(id = employe.id)
    mockChannels = []

    channels_data = CanauxEmp.objects.filter(id_inf=inf.id.id).values('id','id_med','id_inf')
    # Iterate over the channels data and populate the mockChannels list
    for channel_data in channels_data:
        
        channel = {
            "id": channel_data['id'],
            "name": Personne.objects.get(id = Employe.objects.get(id=channel_data['id_med']).id_prs.id ).prenom +" " +Personne.objects.get(id = Employe.objects.get(id=channel_data['id_med']).id_prs.id ).nom ,
            "favorite": False,
            "sender": True,
            "messages": [],
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
                channel['sender'] = True
            else:
                channel['sender'] = False
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
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Infirmier.objects.filter(id=employe.id).exists():
                name = request.user.get_full_name()
                fname = request.user.get_first_name()
                lname = request.user.get_last_name()
                
                channels = CanauxEmp.objects.get(id= id)
                
                name_channel = Personne.objects.get(id = Employe.objects.get(id=channels.id_med.id.id).id_prs.id ).prenom + " " + Personne.objects.get(id = Employe.objects.get(id=channels.id_med.id.id).id_prs.id ).nom 
                if request.method == 'POST':
                    algeria_tz = pytz.timezone('Africa/Algiers')
                    now = timezone.now().astimezone(algeria_tz)
                    date_now =  now.strftime("%Y-%m-%d %H:%M:%S")
                    message = request.POST.get('message')
                    Discussion.objects.create(
                        emetteur = 'infirmier',
                        message = message,
                        date = date_now,
                        id_canaux = channels
                    )
                    response_data = {'status': 'success'}
                    return JsonResponse(response_data)
                context = {'name': name, 'fname':fname, 'lname': lname, 'id':id ,'name_channel':name_channel}
                return render(request, 'infirmier/messages.html', context)
    
    
    


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


        
        if channel_data['emetteur'] == "infirmier":
            channel['own'] = True
        else:
            channel['own'] = False
        mockChannels.append(channel)
    return JsonResponse(mockChannels, safe=False)


@login_required
def notification_infermieur(request):
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
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Infirmier.objects.filter(id=employe.id).exists():
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
                    return redirect('notification_infermieur')
                context = {'name': name, 'fname':fname, 'lname': lname,'notifications' : notifications}
                return render(request, 'infirmier/notification.html', context)
            
      
      
      
      
@login_required
def account_infermieur(request):
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
            elif MedecinChef.objects.filter(id=employe.id).exists():
                return redirect('homemedecinchef')
            elif Infirmier.objects.filter(id=employe.id).exists():
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
                            print("im here4")
                            return redirect('account_infermieur')
                        request.user.email = email
                        request.user.num_telephone = num_telephone
                        request.user.save()
                        print("im here5")
                        update_session_auth_hash(request, request.user)
                        return redirect('account_infermieur')
                    elif form_name == 'changepassword':
                        current_password = request.POST.get('currentPassword')
                        new_password = request.POST.get('newPassword')
                        new_password_confirm = request.POST.get('newPasswordConfirm')

                        if not request.user.check_password(current_password):
                            messages.error(request, 'The current password you entered is incorrect.')
                            return redirect('account_infermieur')

                        if new_password != new_password_confirm:
                            messages.error(request, 'The new passwords you entered do not match.')
                            return redirect('account_infermieur')

                        request.user.set_password(new_password)
                        request.user.save()
                        update_session_auth_hash(request, request.user)
                        messages.success(request, 'Your password has been changed successfully.')
                        return redirect('account_infermieur')
                    elif form_name == 'deletacount':
                        request.user.is_active = False
                        request.user.save()
                        logout(request)
                        return redirect('account_infermieur')
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
                        return redirect('account_infermieur')
                return render(request, 'infirmier/account.html', context)


@login_required
def signout(request):
    logout(request)
    messages.success(request, 'You have successfully logged out.')
    return redirect('/')