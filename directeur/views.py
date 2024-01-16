import ast
import calendar
from datetime import datetime, date, timedelta
from django import template
from django.shortcuts import render,redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from django.contrib import messages
from django.core.mail import send_mail
from quick_lab import settings
from login.models import Patient, Personne
from patient.models import Annulation, Facture, RendezVous
from admin.models import Abonnement
from .models import Branche, ClientLabo, Directeur, Employe, Evaluation, Infirmier, Laboratoire, MedecinChef, PrixAnalyse, Receptionniste, Reclamation, TypeAnalyse
from .backend import generate_password, generate_username, get_employee_role
from django.db import connection
from django.http import HttpResponseBadRequest, JsonResponse
import json
from django.core.serializers import serialize
from django.db.models import F
from django.utils import timezone
from django.core.mail import EmailMessage
from django.contrib.auth import update_session_auth_hash
from accueill.models import Notification

# Create your views here.
@login_required
def homedirecteur(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        today = date.today()
        barnch = Branche.objects.filter(labo=Directeur.objects.get(id=request.user.id).id_lab.id)
        rendezvous = RendezVous.objects.filter(date=today, branche_id__in=barnch)
        start_datetime = datetime.combine(today, datetime.min.time())
        end_datetime = start_datetime + timedelta(days=1)
        annulations = Annulation.objects.filter(date__range=(start_datetime, end_datetime), branche_id__in=barnch)
        prix = 0
        for rdv in rendezvous:
            if Facture.objects.filter(rdv = rdv) :
                facture = Facture.objects.get(rdv = rdv)
                prix = prix + facture.prix
        for anu in annulations:
            prix = prix + anu.prix
        employers = Employe.objects.filter(id_branche__in = barnch).values_list('id_prs', flat=True)
        emp_conicted = Personne.objects.filter(id__in = employers, last_login__range=(start_datetime, end_datetime))
        branche = barnch.count()
        worker = emp_conicted.count()
        appointment = rendezvous.count()
        
        rendezvous_list = []
        current_month = today.month
        months = [calendar.month_name[month] for month in range(1, current_month + 1)]
        sales_mounths = []
        
        directeur  = Directeur.objects.get(id=request.user.id)
        branches = Branche.objects.filter(labo=directeur.id_lab.id).values('id', 'branche_nom')
        directeur  = Directeur.objects.get(id=request.user.id)
        with connection.cursor() as cursor:
            cursor.execute("""
                select e.id,p.id,nom,prenom,last_login,b.id,branche_nom,nom_utilisateur,p.email,p.num_telephone,date_naissance,lieu_naissance,sex
                from personne p,employe e,branche b
                where e.id_prs = p.id 
                and e.id_branche = b.id
                and b.labo = %s
            """, [directeur.id_lab.id])
            employees = cursor.fetchall()
        employee_roles = {}
        for employee in employees:
            employee_id = int(employee[0])
            employee_role = get_employee_role(employee_id)
            employee_roles[str(employee_id)] = employee_role
            
            
       
        context = {'name': name, 'fname':fname, 'lname': lname,'totalsail':prix, 'branche':branche, 'worker':worker,
                   'appointment':appointment,'employees':employees, 'employee_roles': employee_roles, 'branches': branches}

       
        return render(request, 'directeur/homedirecteur.html', context)

@login_required
def gestionemp(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        directeur  = Directeur.objects.get(id=request.user.id)
        branches = Branche.objects.filter(labo=directeur.id_lab.id).values('id', 'branche_nom')
        directeur  = Directeur.objects.get(id=request.user.id)
        with connection.cursor() as cursor:
            cursor.execute("""
                select e.id,p.id,nom,prenom,b.id,branche_nom,nom_utilisateur,p.email,p.num_telephone,date_naissance,lieu_naissance,sex
                from personne p,employe e,branche b
                where e.id_prs = p.id 
                and e.id_branche = b.id
                and b.labo = %s
            """, [directeur.id_lab.id])
            employees = cursor.fetchall()
        employee_roles = {}
        for employee in employees:
            employee_id = int(employee[0])
            employee_role = get_employee_role(employee_id)
            employee_roles[str(employee_id)] = employee_role
            
        context = {'name': name, 'fname':fname, 'lname': lname, 'employees':employees, 'employee_roles': employee_roles, 'branches': branches}
        if request.method == 'POST':
            form_name = request.POST.get('form_name')
            if form_name == 'updatedetail':
                empid = request.POST.get('id')
                empfnam = request.POST.get('fname')
                emplname = request.POST.get('lname')
                empsex = request.POST.get('gender')
                emptype = request.POST.get('type')
                empemail = request.POST.get('email')
                emptel = request.POST.get('Phone_Number')
                empdate = request.POST.get('date_of_birth')
                empplace = request.POST.get('placebirth')
                id = request.POST.get('NIN')
                idbranch = request.POST.get('branch')
                emp = Employe.objects.get(id=empid)
                type = get_employee_role(emp.id)
                myemp = Personne.objects.get(id=emp.id_prs.id)
                if myemp.id is not id:
                    if Personne.objects.filter(id=empid):
                        messages.error(request, " NID already exists! Please try corect nationale carte number.")
                        return redirect('gestionemp')

            
                    myemp = Personne.objects.filter(id=emp.id_prs.id)
                    myemp.update(
                        id=id,
                        nom=emplname,
                        prenom=empfnam,
                        sex=empsex,
                        num_telephone=emptel,
                        date_naissance=empdate,
                        lieu_naissance=empplace,
                        email=empemail
                    )
                    my_employe = Employe.objects.get(id=empid)
                    my_employe.delete()
                    myemp = Personne.objects.get(id=id)
                    myBranche = Branche.objects.get(id=idbranch)
                    new_employe = Employe.objects.create(
                    id_prs=myemp,
                    id_branche=myBranche,
                    )
                    new_employe = Employe.objects.get(id_prs=id)
                    if emptype == 'nurse':
                        Infirmier.objects.create(id =new_employe)
                    elif emptype == 'receptionist':
                        Receptionniste.objects.create(id=new_employe)
                    elif emptype == 'the auditor':
                        MedecinChef.objects.create(id=new_employe)
                else:
                    myemp = Personne.objects.filter(id=id)
                    myemp.update(
                        nom=emplname,
                        prenom=empfnam,
                        sex=empsex,
                        num_telephone=emptel,
                        date_naissance=empdate,
                        lieu_naissance=empplace,
                        email=empemail
                    )
                    if emptype is not type:
                        if type == 'nurse':
                            emp = Infirmier.objects.get(id = emp)
                            emp.delete()
                        elif type == 'receptionist':
                            emp = Receptionniste.objects.get(id=emp)
                            emp.delete()
                        elif type == 'the auditor':
                            emp = MedecinChef.objects.get(id=emp)
                            emp.delete()
                        new_employe = Employe.objects.get(id_prs=id)
                        if emptype == 'nurse':
                            Infirmier.objects.create(id =new_employe)
                        elif emptype == 'receptionist':
                            Receptionniste.objects.create(id=new_employe)
                        elif emptype == 'the auditor':
                            MedecinChef.objects.create(id=new_employe)
                return redirect('gestionemp')
            elif form_name == 'deletemp':
                id = request.POST.get('employe_id') 
                # emp = Employe.objects.get(id_prs=id)
                # type = get_employee_role(emp.id)
                # print(type)
                # if type == 'nurse':
                #     test = Infirmier.objects.get(id = emp)
                #     test.delete()
                # elif type == 'receptionist':
                #     emp = Receptionniste.objects.get(id=emp)
                #     emp.delete()
                # elif type == 'the auditor':
                #     emp = MedecinChef.objects.get(id=emp)
                #     emp.delete()
                myemp = Personne.objects.get(id=id)
                myemp.delete()   
                return redirect('gestionemp')
        return render(request, 'directeur/employes_management.html', context)


@login_required
def addemp(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        directeur  = Directeur.objects.get(id=request.user.id)
        branches = Branche.objects.filter(labo=directeur.id_lab.id).values('id', 'branche_nom')
        
        context = {'name': name, 'fname':fname, 'lname': lname, 'branches': branches}
        if request.method == 'POST':
            empfnam = request.POST.get('fname')
            emplname = request.POST.get('lname')
            empsex = request.POST.get('gender')
            emptype = request.POST.get('type')
            empemail = request.POST.get('email')
            emptel = request.POST.get('tel')
            empdate = request.POST.get('date')
            empplace = request.POST.get('place')
            empid = request.POST.get('numnation')
            idbranch = request.POST.get('branch')
            empuser = generate_username()
            emppass = generate_password()
            if Personne.objects.filter(nom_utilisateur=empuser):
                empuser = generate_username()

            
            if Personne.objects.filter(id=empid):
                messages.error(request, " NID already exists! Please try corect nationale carte number.")
                return redirect('addemp')

            if Personne.objects.filter(email=empemail):
                messages.error(request, "Email already registered!")
                return redirect('addemp')
            
            if Personne.objects.filter(num_telephone=emptel):
                messages.error(request, "phone already exists! Please try a different number.")
                return redirect('addemp')

            subject = 'New Account Created'
            message = f'Hi Employer, a new account has been created with the following credentials:\n\nUsername: {empuser}\nPassword: {emppass}'

            send_mail(
                subject=subject,
                message=message,
                from_email=settings.EMAIL_HOST_USER,
                recipient_list=[empemail],
                fail_silently=False,
            )
            myemployee = Personne(
                id=empid,
                nom=emplname,
                prenom=empfnam,
                sex=empsex,
                num_telephone=emptel,
                date_naissance=empdate,
                lieu_naissance=empplace,
                email=empemail,
                nom_utilisateur=empuser,
                two_factor_enabled = False,
                is_active=True,
            )
            myemployee.set_password(emppass)
            myemployee.save()
            myBranche = Branche.objects.get(id=idbranch)
            new_employe = Employe.objects.create(
                id_prs=myemployee,
                id_branche=myBranche,
            )
            new_employe = Employe.objects.get(id_prs=empid)
            if emptype == 'nurse':
                Infirmier.objects.create(id =new_employe)
            elif emptype == 'receptionist':
                Receptionniste.objects.create(id=new_employe)
            elif emptype == 'the auditor':
                MedecinChef.objects.create(id=new_employe)
            messages.success(request, "employee has been added successfully.")
            return redirect('gestionemp')
        return render(request, 'directeur/add_employe.html', context)

def editemp(request, id):
    if request.method == 'GET' and request.headers.get('x-requested-with') == 'XMLHttpRequest':
        emplye = Personne.objects.get(id=id)
        emp = Employe.objects.get(id_prs=id)
        type = get_employee_role(emp.id)
        barnche = Branche.objects.get(id=emp.id_branche.id)
        serialized_data = serialize('json', [emplye, ])
        data = json.loads(serialized_data)[0]['fields']

        context = {'emplye': data, 'emp':emp.id, 'type': type,'barnche_id':barnche.id, 'branche_name': barnche.branche_nom }
        print(type)
        return JsonResponse(context)
    return HttpResponseBadRequest()

@login_required
def gestanalyse(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        directeur  = Directeur.objects.get(id=request.user.id)
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        anlyses = PrixAnalyse.objects.filter(
        id_lab__id=directeur.id_lab.id
        ).annotate(
            type_analyse=F('code_analyse__type_analyse'),
            nom=F('code_analyse__nom')
        ).values(
            'id',
            'type_analyse',
            'nom',
            'prix'
        )
        context = {'name': name, 'fname':fname, 'lname': lname, 'anlyses':anlyses}
        if request.method == 'POST':
            form_name = request.POST.get('form_name')
            print(form_name)
            if form_name == 'updateanalyse':
                id = request.POST.get('id_update')
                prix = request.POST.get('new_price')
                prix_analyse = PrixAnalyse.objects.get(id=id)
                prix_analyse.prix = prix
                prix_analyse.save()
                return redirect('gestanalyse')
            elif form_name == 'deleteanalyse':
                id = request.POST.get('analyse_id_delet')
                prix = request.POST.get('new_price')
                prix_analyse = PrixAnalyse.objects.get(id=id)
                prix_analyse.delete()
                return redirect('gestanalyse')
    return render(request, 'directeur/analyse_management.html', context)

@login_required
def addanalyse(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        analyses = TypeAnalyse.objects.all()
        context = {'name': name, 'fname':fname, 'lname': lname, 'analyses':analyses}
        if request.method == 'POST':
            directeur  = Directeur.objects.get(id=request.user.id)
            codeanalyse = request.POST.get('analyse')
            prixanalyse = request.POST.get('price')
            anlyse_labo = PrixAnalyse()
            
            anlyse_labo.id_lab = Laboratoire.objects.get(id=directeur.id_lab.id)
            anlyse_labo.code_analyse = TypeAnalyse.objects.get(code=codeanalyse)
            anlyse_labo.prix = prixanalyse
            anlyse_labo.save()
            return redirect('gestanalyse')
    return render(request, 'directeur/add_analyse.html', context)

@login_required
def gestbranch(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        directeur  = Directeur.objects.get(id=request.user.id)
        branches  = Branche.objects.filter(labo=directeur.id_lab.id)
        labo = Laboratoire.objects.get(id =directeur.id_lab.id)
        branches_len = len(branches)
        abbonment = Abonnement.objects.get(id_lab = directeur.id_lab.id)
        context = {'name': name, 'fname':fname, 'lname': lname, 'branches':branches, 'name_labo': labo.nom  , 'nbranch':branches_len, 'abbonment':abbonment }
        if request.method == 'POST':
            form_name = request.POST.get('form_name')
            if form_name == 'updatebranche':
                branche_id = request.POST['id']
                name_branche = request.POST['name']
                address = request.POST['address']
                localisation = request.POST['localisation']
                postcode = request.POST['postcode']
                email = request.POST['email']
                phone_number = request.POST['phone_number']
                days_time_of_work = request.POST['days_time_of_work']
                appointments = request.POST['appointments']
                Branche.objects.filter(id=branche_id).update(
                    branche_nom = name_branche, address = address, localisation = localisation, code_postal = postcode, email=email, num_telephone= phone_number, jour_heur_tarvail =days_time_of_work, num_rdv = appointments
                )
                return redirect('gestbranch')
            elif form_name == 'deletebranch':
                branche_id = request.POST['branche_id_delet']
                branche = Branche.objects.get(id=branche_id)
                branche.delete()
                return redirect('gestbranch')
            elif form_name == 'update_name_labo':
                new_name = request.POST['new_name_laboratory']
                labo.nom = new_name
                labo.save()
                return redirect('gestbranch')
    return render(request, 'directeur/Branche_management.html', context)

@login_required
def addbranch(request):
        if hasattr(request.user, 'patient'):
            return redirect('homepatient')
        elif hasattr(request.user, 'directeur'):
            name = request.user.get_full_name()
            fname = request.user.get_first_name()
            lname = request.user.get_last_name()
            context = {'name': name, 'fname':fname, 'lname': lname}
            if request.method == 'POST':
                # Get form data
                name_branche = request.POST['name']
                address = request.POST['address']
                localisation = request.POST['localisation']
                postcode = request.POST['postcode']
                email = request.POST['email']
                phone_number = request.POST['phone_number']
                days_time_of_work = request.POST['days_time_of_work']
                appointments = request.POST['appointments']
                directeur  = Directeur.objects.get(id=request.user.id)
                labo = Laboratoire.objects.get(id=directeur.id_lab.id)
                branche = Branche(branche_nom = name_branche, address=address, localisation = localisation, code_postal = postcode, email=email, num_telephone= phone_number, jour_heur_tarvail =days_time_of_work, num_rdv = appointments)
                branche.labo = labo
                branche.save()
                # Create branch instance
                return redirect('gestbranch')
        return render(request,'directeur/add_Branche.html',context)
    
@login_required    
def gestclient(request):
    if hasattr(request.user, 'patient'):
            return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        directeur  = Directeur.objects.get(id=request.user.id)
        clients = ClientLabo.objects.filter(id_labo=directeur.id_lab.id)
        patients = {}
        for client in clients:
            # get the patient for this client
            patient_id = client.id_patient_id

            # get the patient information using the ID
            patient = Personne.objects.get(id=patient_id)
            
            # patiente = Patient.objects.filter(id=patient)
            # personne = Personne.objects.filter(id=client.id_patient.id)
            # get the number of appointments made by this patient
            num_appointments = RendezVous.objects.filter(id_patient=patient.id).count()
            patients[patient.id] = {
                'id':patient.id,
                'client_name': f'{patient.prenom} {patient.nom}',
                'date_of_birth': patient.date_naissance,
                'place_of_birth': patient.lieu_naissance,
                'sex': patient.sex,
                'phone_number': patient.num_telephone,
                'email': patient.email,
                'num_appointments': num_appointments,
                'is_bloked' : client.is_bloked,
            }

        context = {'name': name, 'fname':fname, 'lname': lname, 'patients':patients}
        if request.method == 'POST':
            form_name = request.POST.get('form_name')
            if form_name == 'activate':
                patient_id = request.POST['active_client_id']
                etat_patient = ClientLabo.objects.get(id_patient=patient_id)
                etat_patient.is_bloked = False
                etat_patient.save()
                return redirect('gestclient')
            elif form_name == 'bloked':
                patient_id = request.POST['blocked_client_id']
                etat_patient = ClientLabo.objects.get(id_patient=patient_id)
                etat_patient.is_bloked = True
                etat_patient.save()
                return redirect('gestclient')
    return render(request,'directeur/client_management.html',context)







# Create your views here.
@login_required
def statdirecteur(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        
        today = date.today()
        barnch = Branche.objects.filter(labo=Directeur.objects.get(id=request.user.id).id_lab.id)
        rendezvous = RendezVous.objects.filter(date=today, branche_id__in=barnch)
        start_datetime = datetime.combine(today, datetime.min.time())
        end_datetime = start_datetime + timedelta(days=1)
        annulations = Annulation.objects.filter(date__range=(start_datetime, end_datetime), branche_id__in=barnch)
        prix = 0
        for rdv in rendezvous:
            if Facture.objects.filter(rdv = rdv) :
                facture = Facture.objects.get(rdv = rdv)
                prix = prix + facture.prix
        for anu in annulations:
            prix = prix + anu.prix
        employers = Employe.objects.filter(id_branche__in = barnch).values_list('id_prs', flat=True)
        emp_conicted = Personne.objects.filter(id__in = employers, last_login__range=(start_datetime, end_datetime))
        branche = barnch.count()
        worker = emp_conicted.count()
        appointment = rendezvous.count()
        
        rendezvous_list = []
        current_month = today.month
        months = [calendar.month_name[month] for month in range(1, current_month + 1)]
        sales_mounths = []
        
        for month in range(1, current_month + 1):
            sales_mounth = 0
            rendezvous = RendezVous.objects.filter(date__year=today.year, date__month=month, branche_id__in=barnch)
            
            for rdv in rendezvous:
                if Facture.objects.filter(rdv = rdv):
                    facture = Facture.objects.get(rdv = rdv)
                    sales_mounth = sales_mounth + facture.prix
            start_date = datetime(today.year, month, 1)
            end_date = datetime(today.year, month, calendar.monthrange(today.year, month)[1])
            
            # Filter the annulations within the date range and branche
            annulations = Annulation.objects.filter(date__range=(start_date, end_date), branche_id__in=barnch)
            for anu in annulations:
                sales_mounth = sales_mounth + anu.prix
            sales_mounths.append(int(sales_mounth))
            rendezvous_list.append(rendezvous.count())
            
            
        annulation_list = []

        # Iterate over the months
        for month in range(1, current_month + 1):
            # Calculate the start and end dates for the current month
            start_date = datetime(today.year, month, 1)
            end_date = datetime(today.year, month, calendar.monthrange(today.year, month)[1])

            # Filter the annulations within the date range and branche
            annulations = Annulation.objects.filter(date__range=(start_date, end_date), branche_id__in=barnch)

            # Count the number of annulations
            annulation_count = annulations.count()

            # Append the count to the annulation list
            annulation_list.append(annulation_count)
        etoile = []

        for i in range(1, 6):
            count = Evaluation.objects.filter(nombre_etoiles=i,barcnh__in = barnch).count()
            etoile.append(count)

        print(etoile)
        print(sales_mounths)
        context = {'name': name, 'fname':fname, 'lname': lname,'totalsail':prix, 'branche':branche, 'worker':worker,
                   'appointment':appointment, 'mounth': json.dumps(months), 'rendezvous_list':rendezvous_list,
                   'annulation_list':annulation_list, 'sales_mounths':sales_mounths, 'etoile':etoile,}
        return render(request, 'directeur/statistique.html', context)
    

def reclamation(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        directeur = Directeur.objects.get(id = request.user.id)
        with connection.cursor() as cursor:
            # Call the stored procedure with the parameter
            cursor.callproc("GetReclamationDetails", [directeur.id_lab.id])

            # Fetch the results
            columns = [column[0] for column in cursor.description]
            reclamation = [dict(zip(columns, row)) for row in cursor.fetchall()]
        context = {'name': name, 'fname':fname, 'lname': lname, 'reclamations':reclamation}
        if request.method == 'POST':
            form_name = request.POST.get('form_name')
            if form_name == 'delet_rec':
                id = request.POST.get('reclamation_id_delet')
                reclamation = Reclamation.objects.get(id = id)
                reclamation.delete()
                return redirect('reclamation')
            elif form_name == 'reply':
                id = request.POST.get('reclamation_id_reply')
                message_reply = request.POST.get('message_reply')
                reclamation = Reclamation.objects.get(id = id)
                prs = Personne.objects.get(id = Patient.objects.get(id = reclamation.patient.id).id.id)
                subject = 'complaint response'

                email = EmailMessage(
                    subject=subject,
                    body=message_reply,
                    from_email=settings.EMAIL_HOST_USER,
                    to=[prs.email],
                )
                email.send()
                reclamation.delete()
                return redirect('reclamation')
        return render(request, 'directeur/Reclamation.html', context)

def blood_bank(request):
    if hasattr(request.user, 'patient'):
        return redirect('homepatient')
    elif hasattr(request.user, 'directeur'):
        name = request.user.get_full_name()
        fname = request.user.get_first_name()
        lname = request.user.get_last_name()
        directeur = Directeur.objects.get(id = request.user.id)
        with connection.cursor() as cursor:
            cursor.callproc('GetBloodBagsCount', [directeur.id_lab.id])
            columns = [column[0] for column in cursor.description]
            result = [dict(zip(columns, row)) for row in cursor.fetchall()]
        print(result)
        context = {'name': name, 'fname':fname, 'lname': lname, 'blood_bags': result}
        if request.method == 'POST':
            blood_type = request.POST.get('blood_type_input')
            blood_bag = request.POST.get('blood_bag')
            with connection.cursor() as cursor:
                cursor.execute("CALL DeleteBloodBags(%s, %s, %s)", [blood_type, directeur.id_lab.id, blood_bag])
                # Commit the changes if necessary
                connection.commit()
                
                # Get the number of rows affected
                rows_affected = cursor.rowcount
            
            return redirect('blood_bank')
        return render(request, 'directeur/poche_de_sang.html', context)


@login_required
def notification_directeur(request):
    if hasattr(request.user, 'directeur'):
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
            return redirect('notification_directeur')
        # Print the results
        context = {'name': name, 'fname':fname, 'lname': lname,'notifications' : notifications}
        return render(request, 'directeur/notification.html', context)
    else:
        return redirect('signin')
        

@login_required
def account_directeur(request):
    if hasattr(request.user, 'directeur'):
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
       
        context = {'name': name, 'email':email, 'num':num, 'last_login': last_login,
                   'date_cretion':date_cretion, 'date_birth': date_birth, 'sex': sex,
                   'fname':fname, 'lname': lname, 'two_factor':two_factor}
        if request.method == 'POST':
            form_name = request.POST.get('form_name')
            if form_name == 'updateforme':
                email = request.POST.get('email')
                num_telephone = request.POST.get('mobile')
                password = request.POST.get('password')
                if not request.user.check_password(password):
                    messages.error(request, 'Incorrect password. Please try again.')
                    return redirect('account_directeur')
                request.user.email = email
                request.user.num_telephone = num_telephone
                request.user.save()
                update_session_auth_hash(request, request.user)
                return redirect('account_directeur')
            elif form_name == 'changepassword':
                current_password = request.POST.get('currentPassword')
                new_password = request.POST.get('newPassword')
                new_password_confirm = request.POST.get('newPasswordConfirm')

                if not request.user.check_password(current_password):
                    messages.error(request, 'The current password you entered is incorrect.')
                    return redirect('account_directeur')

                if new_password != new_password_confirm:
                    messages.error(request, 'The new passwords you entered do not match.')
                    return redirect('account_directeur')

                request.user.set_password(new_password)
                request.user.save()
                update_session_auth_hash(request, request.user)
                messages.success(request, 'Your password has been changed successfully.')
                return redirect('account_directeur')
            elif form_name == 'deletacount':
                request.user.is_active = False
                request.user.save()
                logout(request)
                return redirect('/')
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

                


                messages.success(request, 'Your profile has been updated successfully!')
                return redirect('account_directeur')
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
                return redirect('account_directeur')
        return render(request, 'directeur/account.html', context)  
    else:
        return redirect('signin')  
    
@login_required
def signout(request):
    logout(request)
    messages.success(request, 'You have successfully logged out.')
    return redirect('/')
