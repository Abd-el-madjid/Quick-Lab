from datetime import timedelta
from django.db import models

from directeur.models import Laboratoire

class Admin(models.Model):
    nom = models.CharField(max_length=45, blank=True, null=True)
    prenom = models.CharField(max_length=45, blank=True, null=True)
    email = models.CharField(unique=True, max_length=60)
    mot_de_pass = models.CharField(max_length=45, blank=True, null=True)
    sex = models.CharField(max_length=45, blank=True, null=True)
    last_login = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'admin'

class Abonnement(models.Model):
    date_debut = models.DateField(blank=True, null=True)
    date_fin = models.DateField(blank=True, null=True)
    type_abonnement = models.CharField(max_length=7, blank=True, null=True)
    statut = models.CharField(max_length=10, blank=True, null=True)
    montant = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    id_lab = models.ForeignKey(Laboratoire, models.DO_NOTHING, db_column='id_lab', blank=True, null=True)
   
    class Meta:
        managed = False
        db_table = 'abonnement'
        
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