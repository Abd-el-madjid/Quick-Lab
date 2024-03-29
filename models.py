# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Abonnement(models.Model):
    date_debut = models.DateField(blank=True, null=True)
    date_fin = models.DateField(blank=True, null=True)
    type_abonnement = models.CharField(max_length=12, blank=True, null=True)
    statut = models.CharField(max_length=10, blank=True, null=True)
    montant = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    id_lab = models.ForeignKey('Laboratoire', models.DO_NOTHING, db_column='id_lab', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'abonnement'


class Admin(models.Model):
    nom = models.CharField(max_length=45, blank=True, null=True)
    prenom = models.CharField(max_length=45, blank=True, null=True)
    email = models.CharField(unique=True, max_length=60, blank=True, null=True)
    mot_de_pass = models.CharField(max_length=45, blank=True, null=True)
    sex = models.CharField(max_length=45, blank=True, null=True)
    last_login = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'admin'


class AnalyseChamp(models.Model):
    code = models.OneToOneField('TypeAnalyse', models.DO_NOTHING, db_column='code', primary_key=True)
    champ_name = models.TextField(blank=True, null=True)
    units = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'analyse_champ'


class Annulation(models.Model):
    id_patient = models.ForeignKey('Patient', models.DO_NOTHING, db_column='id_patient')
    branche_id = models.IntegerField()
    prix = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'annulation'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Branche(models.Model):
    id = models.IntegerField(primary_key=True)
    branche_nom = models.CharField(max_length=120, blank=True, null=True)
    address = models.CharField(max_length=200, blank=True, null=True)
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


class Canaux(models.Model):
    branch = models.ForeignKey(Branche, models.DO_NOTHING, blank=True, null=True)
    pat = models.ForeignKey('Patient', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'canaux'


class CanauxEmp(models.Model):
    id_med = models.IntegerField()
    id_inf = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'canaux_emp'


class ClientLabo(models.Model):
    id_labo = models.OneToOneField('Laboratoire', models.DO_NOTHING, db_column='id_labo', primary_key=True)  # The composite primary key (id_labo, id_patient) found, that is not supported. The first column is selected.
    id_patient = models.ForeignKey('Patient', models.DO_NOTHING, db_column='id_patient')
    is_bloked = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'client_labo'
        unique_together = (('id_labo', 'id_patient'),)


class Communication(models.Model):
    emetteur = models.CharField(max_length=11)
    message = models.TextField(blank=True, null=True)
    date = models.DateTimeField()
    canaux = models.ForeignKey(Canaux, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'communication'


class Conseille(models.Model):
    conseille = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'conseille'


class ConseilleAnalyse(models.Model):
    code_analyse = models.ForeignKey('TypeAnalyse', models.DO_NOTHING, db_column='code_analyse')
    id_conseille = models.ForeignKey(Conseille, models.DO_NOTHING, db_column='id_conseille')

    class Meta:
        managed = False
        db_table = 'conseille_analyse'


class Directeur(models.Model):
    id = models.OneToOneField('Personne', models.DO_NOTHING, db_column='id', primary_key=True)
    id_lab = models.ForeignKey('Laboratoire', models.DO_NOTHING, db_column='id_lab', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'directeur'


class Discussion(models.Model):
    emetteur = models.CharField(max_length=11, blank=True, null=True)
    message = models.TextField(blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)
    id_canaux = models.ForeignKey(CanauxEmp, models.DO_NOTHING, db_column='id_canaux', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'discussion'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Employe(models.Model):
    id = models.IntegerField(primary_key=True)
    id_prs = models.ForeignKey('Personne', models.DO_NOTHING, db_column='id_prs')
    id_branche = models.ForeignKey(Branche, models.DO_NOTHING, db_column='id_branche', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'employe'


class Evaluation(models.Model):
    patient = models.ForeignKey('Patient', models.DO_NOTHING, blank=True, null=True)
    barcnh = models.ForeignKey(Branche, models.DO_NOTHING, blank=True, null=True)
    nombre_etoiles = models.IntegerField(blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'evaluation'


class Facture(models.Model):
    id = models.PositiveBigIntegerField(primary_key=True)
    statut = models.CharField(max_length=7, blank=True, null=True)
    chemin_facture = models.TextField(blank=True, null=True)
    prix = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    rdv = models.ForeignKey('RendezVous', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'facture'


class Infirmier(models.Model):
    id = models.OneToOneField(Employe, models.DO_NOTHING, db_column='id', primary_key=True)

    class Meta:
        managed = False
        db_table = 'infirmier'


class Laboratoire(models.Model):
    id = models.IntegerField(primary_key=True)
    nom = models.CharField(max_length=45, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'laboratoire'


class MedecinChef(models.Model):
    id = models.OneToOneField(Employe, models.DO_NOTHING, db_column='id', primary_key=True)

    class Meta:
        managed = False
        db_table = 'medecin_chef'


class Notification(models.Model):
    date = models.DateTimeField(blank=True, null=True)
    contenu = models.TextField(blank=True, null=True)
    id_prs = models.ForeignKey('Personne', models.DO_NOTHING, db_column='id_prs', blank=True, null=True)
    is_read = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'notification'


class Patient(models.Model):
    id = models.OneToOneField('Personne', models.DO_NOTHING, db_column='id', primary_key=True)
    maladie = models.TextField(blank=True, null=True)
    type_sang = models.CharField(max_length=3, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'patient'


class Payment(models.Model):
    rdv = models.ForeignKey('RendezVous', models.DO_NOTHING, blank=True, null=True)
    charge_id = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    card_last4 = models.CharField(max_length=4)
    card_brand = models.CharField(max_length=20)
    payment_status = models.CharField(max_length=7)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'payment'


class PaymentLab(models.Model):
    abbonment = models.ForeignKey(Abonnement, models.DO_NOTHING)
    charge_id = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    card_last4 = models.CharField(max_length=4)
    card_brand = models.CharField(max_length=100)
    payment_status = models.CharField(max_length=50)
    created_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'payment_lab'


class Personne(models.Model):
    id = models.BigIntegerField(primary_key=True)
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

    class Meta:
        managed = False
        db_table = 'personne'


class PocheSang(models.Model):
    quantite_ml = models.IntegerField()
    id_rdv = models.ForeignKey('RendezVous', models.DO_NOTHING, db_column='id_rdv')
    is_accepted = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'poche_sang'


class PrixAnalyse(models.Model):
    id_lab = models.ForeignKey(Laboratoire, models.DO_NOTHING, db_column='id_lab', blank=True, null=True)
    code_analyse = models.ForeignKey('TypeAnalyse', models.DO_NOTHING, db_column='code_analyse', blank=True, null=True)
    prix = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'prix_analyse'


class Promotion(models.Model):
    date_debut = models.DateField()
    date_fin = models.DateField()
    pourcentage = models.DecimalField(max_digits=5, decimal_places=2)
    description = models.TextField(blank=True, null=True)
    statut = models.CharField(max_length=7)
    lab = models.ForeignKey(Laboratoire, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'promotion'


class Rapport(models.Model):
    id = models.IntegerField(primary_key=True)
    med = models.ForeignKey(MedecinChef, models.DO_NOTHING, blank=True, null=True)
    rapport = models.TextField(blank=True, null=True)
    resultat = models.ForeignKey('Resultat', models.DO_NOTHING, blank=True, null=True)
    is_validate = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'rapport'


class Receptionniste(models.Model):
    id = models.OneToOneField(Employe, models.DO_NOTHING, db_column='id', primary_key=True)

    class Meta:
        managed = False
        db_table = 'receptionniste'


class Reclamation(models.Model):
    reclamation_text = models.TextField(blank=True, null=True)
    patient = models.ForeignKey(Patient, models.DO_NOTHING, blank=True, null=True)
    branche = models.ForeignKey(Branche, models.DO_NOTHING, blank=True, null=True)
    reclamation_object = models.CharField(max_length=45, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'reclamation'


class RendezVous(models.Model):
    date = models.DateField(blank=True, null=True)
    heur = models.TimeField(blank=True, null=True)
    analyes = models.TextField(blank=True, null=True)
    type_rdv = models.CharField(max_length=8, blank=True, null=True)
    etat = models.CharField(max_length=6, blank=True, null=True)
    purpose = models.CharField(max_length=14, blank=True, null=True)
    id_patient = models.ForeignKey(Patient, models.DO_NOTHING, db_column='id_patient', blank=True, null=True)
    branche = models.ForeignKey(Branche, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'rendez_vous'


class Resultat(models.Model):
    resultat = models.TextField(blank=True, null=True)
    tube = models.ForeignKey('TubeAnalyse', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'resultat'


class ResultatRapportPdf(models.Model):
    id = models.PositiveBigIntegerField(primary_key=True)
    chemin = models.CharField(max_length=200)
    id_resultat = models.ForeignKey(Resultat, models.DO_NOTHING, db_column='id_resultat', blank=True, null=True)
    id_rapport = models.ForeignKey(Rapport, models.DO_NOTHING, db_column='id_rapport', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'resultat_rapport_pdf'


class TravailInfermier(models.Model):
    id_infermier = models.OneToOneField(Infirmier, models.DO_NOTHING, db_column='id_infermier', primary_key=True)  # The composite primary key (id_infermier, id_rdv) found, that is not supported. The first column is selected.
    id_rdv = models.ForeignKey(RendezVous, models.DO_NOTHING, db_column='id_rdv')
    is_terminer = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'travail_infermier'
        unique_together = (('id_infermier', 'id_rdv'),)


class TubeAnalyse(models.Model):
    id = models.BigIntegerField(primary_key=True)
    code_analyse = models.ForeignKey('TypeAnalyse', models.DO_NOTHING, db_column='code_analyse', blank=True, null=True)
    infirmier = models.ForeignKey(Infirmier, models.DO_NOTHING, db_column='infirmier', blank=True, null=True)
    rdv = models.ForeignKey(RendezVous, models.DO_NOTHING, db_column='rdv', blank=True, null=True)
    is_done = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tube_analyse'


class TypeAnalyse(models.Model):
    code = models.CharField(primary_key=True, max_length=20)
    type_analyse = models.CharField(max_length=100, blank=True, null=True)
    nom = models.CharField(max_length=200, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'type_analyse'
