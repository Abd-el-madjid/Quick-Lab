import base64
from datetime import date, datetime, timedelta
from decimal import ROUND_DOWN, Decimal
import os
import subprocess
from django.contrib.auth.tokens import default_token_generator
from django.core.signing import TimestampSigner
from django.http import HttpResponse
from django_otp import user_has_device

from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from quick_lab import settings
from django.shortcuts import redirect, render
from django.contrib import messages
from django.template.loader import render_to_string
from django.contrib.sites.shortcuts import get_current_site
from django.db.models import Max
from django.template.loader import get_template

from patient.models import Conseille, RendezVous
from directeur.models import Branche, Directeur, Laboratoire, PrixAnalyse, TypeAnalyse
from django.utils.http import urlsafe_base64_encode
from django.contrib.auth import login, authenticate
from django.utils.encoding import force_bytes, force_str

from admin.models import Abonnement, PaymentLab 
from . tokens import generate_token
from django.core.mail import EmailMessage
from django.utils.html import strip_tags
from django.core.mail import send_mail
from .models import Patient, Personne, Employe, Infirmier, MedecinChef, Receptionniste
from cryptography.fernet import Fernet
from django.shortcuts import render
from login.backends import PersonneBackend
import stripe
from django.conf import settings
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile

def signin(request):
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
                return redirect('homereceptionniste')      
        
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        personne = PersonneBackend()
        user = personne.authenticate(request, username=username, password=password)
        if user is not None:
            if user.is_active:
                if user.two_factor_enabled:  # Check if two-factor authentication is enabled for the user
                    # Render the template with the verification code input form
                    return render(request, 'login/sms.html', {'user_id': user.id})
                else:
                    login(request, user, backend='login.backends.PersonneBackend')
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
                        return redirect('homereceptionniste')
                    
            else:
                messages.error(request, 'Your account is not active.')
        else:
            messages.error(request, 'Invalid username or password.')
    return render(request, 'login/login.html')




def verify_code(request):
    
    if request.method == 'POST':
        verification_code = request.POST['verification_code']
        user_id = request.POST['user_id']

        # Get the user based on the user_id
        user = PersonneBackend().get_user(user_id)

        if user is not None:
            # Check if the verification code matches
            if user.two_factor_secret == verification_code:
                login(request, user, backend='login.backends.PersonneBackend')
                # Redirect the user to the appropriate page based on their role
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
                        return redirect('homereceptionniste')
            else:
                messages.error(request, 'Invalid verification code.')
        else:
            messages.error(request, 'User not found.')

        return render(request, 'login/sms.html',{'user_id': user_id})
    return redirect('signin')



def registration(request):
    if request.method == "POST":
        id = request.POST['id']
        nom = request.POST['Nom']
        prenom = request.POST['Prenom']
        sex = request.POST['gender']
        telephone = request.POST['telephone']
        date = request.POST['date']
        lieu = request.POST['lieu']
        email = request.POST['email']
        username = request.POST['username']
        pass1 = request.POST['pass1']
        pass2 = request.POST['pass2']
        if Personne.objects.filter(nom_utilisateur=username):
            messages.error(request, "Username already exists! Please try a different username.")
            return redirect('signup')
        
        if Personne.objects.filter(id=id):
            messages.error(request, " NID already exists! Please try your nationale carte number.")
            return redirect('signup')

        if Personne.objects.filter(email=email):
            messages.error(request, "Email already registered!")
            return redirect('signup')
        
        if Personne.objects.filter(num_telephone=telephone):
            messages.error(request, "phone already exists! Please try a different number.")
            return redirect('signup')

        if len(username) > 10:
            messages.error(request, "Username must be under 10 characters")
            return redirect('signup')
        if pass1 != pass2:
            messages.error(request, "Passwords didn't match!")
            return redirect('signup')
        myPersonne = Personne()
        myPersonne.id = id
        myPersonne.nom = nom
        myPersonne.prenom = prenom
        myPersonne.sex = sex
        myPersonne.num_telephone = telephone
        myPersonne.date_naissance = date
        myPersonne.lieu_naissance = lieu
        myPersonne.email = email
        myPersonne.nom_utilisateur = username
        myPersonne.is_active = False
        myPersonne.set_password(pass1)
        myPersonne.two_factor_enabled = False
        myPersonne.save()
        Patient.objects.create(id=myPersonne)
        # Email Address Confirmation Email
        current_site = get_current_site(request)
        email_subject = "Confirm your Email"
        message2 = render_to_string('login/email_confirmation.html', {
            'name': myPersonne.get_full_name,
            'domain': current_site.domain,
            'uid': urlsafe_base64_encode(force_bytes(id)),
            'token': generate_token.make_token(myPersonne)
        })
        email = EmailMessage(
            email_subject,
            message2,
            settings.EMAIL_HOST_USER,
            [myPersonne.email],
        )
        email.fail_silently = True
        email.send()
        messages.success(request, "we send email of confirmation")
        return redirect("signin")
    return render(request, 'login/sign_up.html')



    
def activate(request, uidb64, token):
    try:
        uid = force_str(urlsafe_base64_decode(uidb64))
        myuser = Personne.objects.get(id=uid)
    except (TypeError, ValueError, OverflowError, Personne.DoesNotExist):
        myuser = None

    if myuser is not None and generate_token.check_token(myuser, token):
        print('im here')
        myuser.is_active = True
        myuser.save()
        login(request, myuser, backend='login.backends.PersonneBackend')
        messages.success(request, "Your account has been activated!")
        
        return redirect("signin")
    else:
        messages.error(request, "Your account is not activated. Try Again.")
        return render(request, 'login/login.html')





def send_reset_password_email(email, reset_link):
    subject = 'Reset Your Password'
    html_message = render_to_string('login/reset_password_email.html', {'reset_link': reset_link})
    plain_message = strip_tags(html_message)
    from_email = settings.EMAIL_HOST_USER  
    recipient_list = [email]
    send_mail(subject, plain_message, from_email, recipient_list, html_message=html_message)

def forgot_password(request):
    if request.method == 'POST':
        email = request.POST['email']
        try:
            user = Personne.objects.get(email=email)
        except Personne.DoesNotExist:
            user = None

        if user is not None:
            token = default_token_generator.make_token(user)
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            reset_link = request.build_absolute_uri('/login/reset_password/{}/{}'.format(uid, token))
            # Send reset password link to user's email
            send_reset_password_email(user.email, reset_link)
            messages.success(request, 'Reset password link has been sent to your email.')
            return redirect("signin")  
        else:
            messages.error(request, 'The provided email does not exist in our system.')

    return render(request, 'login/mot_pass_oblie.html')



def reset_password(request, uidb64, token):
    try:
        uid = urlsafe_base64_decode(uidb64).decode()
        user = Personne.objects.get(pk=uid)
    except(TypeError, ValueError, OverflowError, Personne.DoesNotExist):
        user = None

    if user is not None and default_token_generator.check_token(user, token):
        if request.method == 'POST':
            pass1 = request.POST['pass1']
            pass2 = request.POST['pass2']
            if pass1 != pass2:
                messages.error(request, "Passwords didn't match!")
                return redirect('reset_password', uidb64=uidb64, token=token)
            user.set_password(pass1)
            user.save()
            login(request, user, backend='login.backends.PersonneBackend')
            messages.success(request, 'Your password has been reset successfully.')
            return redirect("/")  

        return render(request, 'login/email_mot_pass_oblie.html')
    else:
        messages.error(request, 'The password reset link is invalid or has expired.')
        return redirect('forgot_password')  


def appointment_detail(request, encrypted_id):
    encryption_key = b'0jZopyHQyZUzgREXckBDsyyHqXDmhVPMtFqePm1wlCs='
    try:
        appointment_id = int(Fernet(encryption_key).decrypt(encrypted_id.encode()).decode())
        print(appointment_id)
    except (ValueError, TypeError):
        # Handle invalid or missing ID gracefully
        return render(request, 'invalid_qr_code.html')
    rdv = RendezVous.objects.get(id=appointment_id)
    patient = Personne.objects.get(id= (Patient.objects.get(id = rdv.id_patient.id )).id.id)  
    name_patient = patient.prenom + " " + patient.nom
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
    context = {'name_user': name_patient, 'tel': patient.num_telephone,
                'rdv': rdv, 'name_analyses':name_analyses, 
               'prix':prix, 'analyses_labs':analyses_lab, 'appointment':rdv, 
               'branch':labo, 
               'rdv_booked':branch_rdv_details,
               'conseilles':conseilles}    
    return render(request, 'login/Appointment.html',context)



def signup_labo(request):
    if request.method == 'POST':
        lab_name = request.POST.get('lab')
        abbonment = request.POST.get('abbonment')
        national_id = request.POST.get('id')
        first_name = request.POST.get('fname')
        last_name = request.POST.get('lname')
        date_of_birth = request.POST.get('date_birth')
        place_of_birth = request.POST.get('place_birth')
        gender = request.POST.get('gender')
        email = request.POST.get('email')
        print(email)
        phone_number = request.POST.get('num_phone')
        username = request.POST.get('username')
        password = request.POST.get('pass1')
        password_confirmation = request.POST.get('pass2')
        if Personne.objects.filter(nom_utilisateur=username):
            messages.error(request, "Username already exists! Please try a different username.")
            return redirect('signup_labo')
        
        if Personne.objects.filter(id=national_id):
            messages.error(request, " NID already exists! Please try your nationale carte number.")
            return redirect('signup_labo')

        if Personne.objects.filter(email=email):
            messages.error(request, "Email already registered!")
            return redirect('signup_labo')
        
        if Personne.objects.filter(num_telephone=phone_number):
            messages.error(request, "phone already exists! Please try a different number.")
            return redirect('signup_labo')

        if len(username) > 10:
            messages.error(request, "Username must be under 10 characters")
            return redirect('signup_labo')
        if password != password_confirmation:
            messages.error(request, "Passwords didn't match!")
            return redirect('signup_labo')
        max_id = Laboratoire.objects.aggregate(max_id=Max('id'))['max_id']
        new_id = max_id + 1 if max_id is not None else 1001
        lab = Laboratoire.objects.create(id =new_id, nom  = lab_name)
        directeur = Personne()
        directeur.id = national_id
        directeur.nom = last_name
        directeur.prenom = first_name
        directeur.sex = gender
        directeur.num_telephone = phone_number
        directeur.date_naissance = date_of_birth
        directeur.lieu_naissance = place_of_birth
        directeur.email = email
        directeur.nom_utilisateur = username
        directeur.is_active = False
        directeur.set_password(password)
        directeur.two_factor_enabled = False
        directeur.save()
        Directeur.objects.create(id=directeur, id_lab = lab)
        date_debut = date.today()
        duration_mapping = {
            "one_month": timedelta(days=30),
            "three_months": timedelta(days=90),
            "one_year": timedelta(days=365)
        }
        duration = duration_mapping.get(abbonment)
        date_fin = date_debut + duration
        Abonnement.objects.create(date_debut=date_debut,date_fin = date_fin, statut='en attente', id_lab = lab)
        messages.success(request, "Your account is awaiting activation, we send email with detail.")
        return redirect("/")
    return render(request, 'login/sign_up_labo.html')


def payment(request, uidb64, token):
    try:
        uid = urlsafe_base64_decode(uidb64).decode()
        user = Personne.objects.get(pk=uid)
        abbonment = Abonnement.objects.get(id_lab = Directeur.objects.get(id = uid).id_lab.id)
        today = date.today()
        number_of_days = (abbonment.date_fin - today).days
        prix = Decimal(number_of_days * 1000).quantize(Decimal('0.00'), rounding=ROUND_DOWN)
        context = {'prix' : prix,}
    except(TypeError, ValueError, OverflowError, Personne.DoesNotExist):
        user = None

    if user is not None and default_token_generator.check_token(user, token):
        if request.method == 'POST':
            carte = request.POST['num_carte']
            date_cart = request.POST['date_exp']
            code_carte = request.POST['code_s']
            year, month = date_cart.split("-")
            signature_image = request.POST.get('signature_image', '')

            # Extract the image data from the data URL
            if signature_image.startswith('data:image/png;base64,'):
                signature_image = signature_image[len('data:image/png;base64,'):]

            # Define the desired file name and extension
            file_name = 'signature-'+str(user.id)+str(abbonment.id)+'.png'

            # Define the desired file path
            file_path = os.path.join('signature', file_name)

            # Get the full absolute file path
            file_path = default_storage.path(file_path)

            # Decode and save the image file
            decoded_image = base64.b64decode(signature_image)

            with open(file_path, 'wb') as f:
                f.write(decoded_image)

    
            stripe.api_key = settings.STRIPE_SECRET_KEY
                # Create a test token
            customer = stripe.Customer.create(
                email=user.email,
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
                amount=int(prix),
                currency='usd',
                description='Payment',
                source=token.id,

                )
                    # store the charge_id in the database
                
                payment = PaymentLab.objects.create(
                    abbonment=abbonment,
                    charge_id=charge.id,
                    amount=prix,
                    card_last4=charge.source.last4,
                    card_brand=charge.source.brand,
                    payment_status='success',
                    created_at=datetime.now()
                )
                payment.save()
                abbonment.statut = 'actif'
                abbonment.montant = prix
                abbonment.save()

                pers = Personne.objects.get(id = (Directeur.objects.get(id_lab = abbonment.id_lab.id)).id.id)
                lab = Laboratoire.objects.get(id = abbonment.id_lab.id)
                template = get_template('login/contracte.html')
                
                context = {
                    'name': pers.prenom + " " + pers.nom,
                    'tel': pers.num_telephone,
                    'email': pers.email,
                    'tid':payment.charge_id,
                    'datetid':payment.created_at,
                    'Lab': lab.nom,
                    'abbonmentdebut': abbonment.date_debut,
                    'abbonmentfin':abbonment.date_fin, 
                    'prix':prix,
                    'singnyateur':file_name,
                    
                }





                html_string = template.render(context)




                
                filename = 'contracte-{}.pdf'.format(pers.id)
                output_dir = os.path.join('pdf','contracte')
                os.makedirs(output_dir, exist_ok=True)
                file_path = os.path.join(output_dir, filename)

                command = ['wkhtmltopdf', '-', file_path]

                # Assuming `html_string` contains the HTML content for the invoice
                try:
                    html_bytes = html_string.encode('utf-8')  # Encode html_string as bytes
                    subprocess.run(command, input=html_bytes, check=True)
                    subject = 'contracte'
                    message = f'Hi Director this is your contracte, '

                    email = EmailMessage(
                        subject=subject,
                        body=message,
                        from_email=settings.EMAIL_HOST_USER,
                        to=[pers.email],
                        attachments=[(filename, open(file_path, 'rb').read(), 'application/pdf')],
                    )
                    email.send()
                    
                    print('PDF successfully generated.')
                except subprocess.CalledProcessError as e:
                    print('Error generating PDF:', e)

                 
            except subprocess.CalledProcessError as e:
                return redirect('payment', uidb64=uidb64, token=token)
            
            user.is_active = True
            user.save()
            
            return redirect("/")  

        return render(request, 'login/payment.html',context)
    else:
        messages.error(request, 'The password reset link is invalid or has expired.')
        return redirect('/')  
