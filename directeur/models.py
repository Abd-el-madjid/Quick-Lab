from django.db import models
from login.models import Personne, Patient

class Laboratoire(models.Model):
    id = models.IntegerField(primary_key=True)
    nom = models.CharField(max_length=45, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'laboratoire'
        
class Directeur(models.Model):
    id = models.OneToOneField(Personne, models.DO_NOTHING, db_column='id', primary_key=True)
    id_lab = models.ForeignKey(Laboratoire, models.DO_NOTHING, db_column='id_lab', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'directeur'
        

        
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
        

class Employe(models.Model):
    id = models.IntegerField(primary_key=True)
    id_prs = models.ForeignKey(Personne, on_delete=models.CASCADE, related_name='employes', db_column='id_prs')
    id_branche = models.ForeignKey(Branche, models.DO_NOTHING, db_column='id_branche', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'employe'

class Receptionniste(models.Model):
    id = models.OneToOneField(Employe, models.DO_NOTHING, db_column='id', primary_key=True)

    class Meta:
        managed = False
        db_table = 'receptionniste'
        
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

class TypeAnalyse(models.Model):
    code = models.CharField(primary_key=True, max_length=20)
    type_analyse = models.CharField(max_length=100, blank=True, null=True)
    nom = models.CharField(max_length=200, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'type_analyse'
        
class PrixAnalyse(models.Model):
    id = models.IntegerField(primary_key=True)
    id_lab = models.ForeignKey(Laboratoire, models.DO_NOTHING, db_column='id_lab', blank=True, null=True)
    code_analyse = models.ForeignKey('TypeAnalyse', models.DO_NOTHING, db_column='code_analyse', blank=True, null=True)
    prix = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'prix_analyse'
        
class ClientLabo(models.Model):
    id_labo = models.ForeignKey('Laboratoire', models.DO_NOTHING, db_column='id_labo')
    id_patient = models.OneToOneField(Patient, models.DO_NOTHING, db_column='id_patient', primary_key=True)  # The composite primary key (id_patient, id_labo) found, that is not supported. The first column is selected.
    is_bloked = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'client_labo'
        unique_together = (('id_patient', 'id_labo'),)
        
        
        
class Reclamation(models.Model):
    reclamation_text = models.TextField(blank=True, null=True)
    patient = models.ForeignKey(Patient, models.DO_NOTHING, blank=True, null=True)
    branche = models.ForeignKey(Branche, models.DO_NOTHING, blank=True, null=True)
    reclamation_object = models.CharField(max_length=45, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'reclamation'
        
class Evaluation(models.Model):
    patient = models.ForeignKey(Patient, models.DO_NOTHING, blank=True, null=True)
    barcnh = models.ForeignKey(Branche, models.DO_NOTHING, blank=True, null=True)
    nombre_etoiles = models.IntegerField(blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'evaluation'