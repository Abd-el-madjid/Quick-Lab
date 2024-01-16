from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.db import models

class PersonneManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        extra_fields.setdefault('is_staff', False)

        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)

        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self.create_user(email, password, **extra_fields)


class Personne(AbstractBaseUser):
    id = models.IntegerField(primary_key=True)
    nom = models.CharField(max_length=45)
    prenom = models.CharField(max_length=45)
    date_naissance = models.DateField()
    lieu_naissance = models.CharField(max_length=45)
    sex = models.CharField(max_length=5)
    email = models.CharField(unique=True, max_length=60)
    num_telephone = models.CharField(unique=True, max_length=13)
    nom_utilisateur = models.CharField(unique=True, max_length=45)
    mot_passe = models.CharField(max_length=100)
    is_active = models.IntegerField()
    last_login = models.DateTimeField(blank=True, null=True)
    date_creation = models.DateTimeField(blank=True, null=True)
    two_factor_enabled = models.IntegerField()
    two_factor_secret = models.CharField(max_length=255, blank=True, null=True)



    objects = PersonneManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['nom', 'prenom', 'date_naissance', 'lieu_naissance', 'sex', 'num_telephone', 'nom_utilisateur']

    class Meta:
        managed = False
        db_table = 'personne'
    
    def get_first_name(self):
        return self.prenom
    
    def get_last_name(self):
        return self.nom
    
    def get_full_name(self):
        return f'{self.prenom} {self.nom}'

    def get_short_name(self):
        return self.prenom

    def get_email(self):
        return self.email
    
    def get_last_login(self):
        return self.last_login
    
    def get_cration_date(self):
        return self.date_creation
    
    def get_date_birth(self):
        return self.date_naissance
    
    def get_sex(self):
        return self.sex
    
    def get_num_telefone(self):
        return self.num_telephone
    
    def has_perm(self, perm, obj=None):
        return self.is_superuser

    def has_module_perms(self, app_label):
        return self.is_superuser
    def two_factor(self):
        if self.two_factor_enabled == True :
            return True
        else :
            return False
    @property
    def password(self):
        return self.mot_passe
    @password.setter
    def password(self, value):
        self.mot_passe = value
    
   

class Patient(models.Model):
    id = models.OneToOneField('Personne', models.DO_NOTHING, db_column='id', primary_key=True)
    maladie = models.TextField(blank=True, null=True)
    type_sang = models.CharField(max_length=3, null=True)

    class Meta:
        managed = False
        db_table = 'patient'
        
    def get_type_sang(self):
        return self.type_sang




class Employe(models.Model):
    id = models.IntegerField(primary_key=True)
    id_prs = models.ForeignKey('Personne', models.DO_NOTHING, db_column='id_prs')
    id_branche = models.ForeignKey('Branche', models.DO_NOTHING, db_column='id_branche', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'employe'
        
class Infirmier(models.Model):
    id = models.OneToOneField(Employe, models.DO_NOTHING, db_column='id', primary_key=True)

    class Meta:
        managed = False
        db_table = 'infirmier'

class MedecinChef(models.Model):
    id = models.OneToOneField(Employe, models.DO_NOTHING, db_column='id', primary_key=True)

    class Meta:
        managed = False
        db_table = 'medecin_chef'



class Receptionniste(models.Model):
    id = models.OneToOneField(Employe, models.DO_NOTHING, db_column='id', primary_key=True)

    class Meta:
        managed = False
        db_table = 'receptionniste'
        
class Laboratoire(models.Model):
    id = models.IntegerField(primary_key=True)
    nom = models.CharField(max_length=45, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'laboratoire'
        
class Branche(models.Model):
    id = models.IntegerField(primary_key=True)
    branche_nom = models.CharField(max_length=120, blank=True, null=True)
    localisation = models.CharField(max_length=45, blank=True, null=True)
    code_postal = models.CharField(max_length=10, blank=True, null=True)
    email = models.CharField(max_length=45, blank=True, null=True)
    num_telephone = models.CharField(max_length=13, blank=True, null=True)
    jour_heur_tarvail = models.TextField(blank=True, null=True)
    num_rdv = models.IntegerField(blank=True, null=True)
    labo = models.ForeignKey('Laboratoire', models.DO_NOTHING, db_column='labo', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'branche'
        
