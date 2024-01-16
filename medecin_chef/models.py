from django.db import models

from login.models import MedecinChef
from infirmier.models import Resultat
from directeur.models import Branche
from patient.models import RendezVous

class Rapport(models.Model):
    id = models.IntegerField(primary_key=True)
    med = models.ForeignKey(MedecinChef, models.DO_NOTHING, blank=True, null=True)
    rapport = models.TextField(blank=True, null=True)
    resultat = models.ForeignKey(Resultat, models.DO_NOTHING, blank=True, null=True)
    is_validate = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'rapport'
        
class ResultatRapportPdf(models.Model):
    id = models.BigIntegerField(primary_key=True)
    chemin = models.CharField(max_length=200)
    id_resultat = models.ForeignKey(Resultat, models.DO_NOTHING, db_column='id_resultat', blank=True, null=True)
    id_rapport = models.ForeignKey(Rapport, models.DO_NOTHING, db_column='id_rapport', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'resultat_rapport_pdf'
        
class PocheSang(models.Model):
    quantite_ml = models.IntegerField()
    id_rdv = models.ForeignKey(RendezVous, models.DO_NOTHING, db_column='id_rdv')
    is_accepted = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'poche_sang'