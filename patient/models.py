from django.db import models
from directeur.models import Branche, TypeAnalyse
from login.models import Infirmier, Patient

class RendezVous(models.Model):
    date = models.DateField(blank=True, null=True)
    heur = models.TimeField(blank=True, null=True)
    analyes = models.TextField(blank=True, null=True)
    type_rdv = models.CharField(max_length=8, blank=True, null=True)
    etat = models.CharField(max_length=9, blank=True, null=True)
    purpose = models.CharField(max_length=14, blank=True, null=True)
    id_patient = models.ForeignKey(Patient, models.DO_NOTHING, db_column='id_patient', blank=True, null=True)
    branche = models.ForeignKey(Branche, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'rendez_vous'

class Facture(models.Model):
    id = models.IntegerField(primary_key=True)
    statut = models.CharField(max_length=7, blank=True, null=True)
    chemin_facture = models.TextField(blank=True, null=True)
    prix = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    rdv = models.ForeignKey('RendezVous', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'facture'
        
class Payment(models.Model):
    rdv = models.ForeignKey('RendezVous', models.DO_NOTHING)
    charge_id = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    card_last4 = models.CharField(max_length=4)
    card_brand = models.CharField(max_length=20)
    payment_status = models.CharField(max_length=7)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'payment'

class Annulation(models.Model):
    id_patient = models.ForeignKey(Patient, models.DO_NOTHING, db_column='id_patient')
    branche = models.ForeignKey(Branche, models.DO_NOTHING)
    prix = models.DecimalField(max_digits=10, decimal_places=2)
    date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'annulation'

class TravailInfermier(models.Model):
    id_infermier = models.OneToOneField(Infirmier, models.DO_NOTHING, db_column='id_infermier', primary_key=True)  # The composite primary key (id_infermier, id_rdv) found, that is not supported. The first column is selected.
    id_rdv = models.ForeignKey(RendezVous, models.DO_NOTHING, db_column='id_rdv')
    is_terminer = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'travail_infermier'
        unique_together = (('id_infermier', 'id_rdv'),)
        
        
class Canaux(models.Model):
    branch = models.ForeignKey(Branche, models.DO_NOTHING, blank=True, null=True)
    pat = models.ForeignKey(Patient, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'canaux'
        
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
    code_analyse = models.ForeignKey(TypeAnalyse, models.DO_NOTHING, db_column='code_analyse')
    id_conseille = models.ForeignKey(Conseille, models.DO_NOTHING, db_column='id_conseille')

    class Meta:
        managed = False
        db_table = 'conseille_analyse'