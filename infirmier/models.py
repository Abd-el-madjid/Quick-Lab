from django.db import models

from login.models import Infirmier
from patient.models import RendezVous
from directeur.models import MedecinChef, TypeAnalyse

# Create your models here.
class TubeAnalyse(models.Model):
    id = models.IntegerField(primary_key=True)
    code_analyse = models.ForeignKey(TypeAnalyse, models.DO_NOTHING, db_column='code_analyse', blank=True, null=True)
    infirmier = models.ForeignKey(Infirmier, models.DO_NOTHING, db_column='infirmier', blank=True, null=True)
    rdv = models.ForeignKey(RendezVous, models.DO_NOTHING, db_column='rdv', blank=True, null=True)
    is_done = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tube_analyse'

class AnalyseChamp(models.Model):
    code = models.OneToOneField(TypeAnalyse, models.DO_NOTHING, db_column='code', primary_key=True)
    champ_name = models.TextField(blank=True, null=True)
    units = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'analyse_champ'

class Resultat(models.Model):
    resultat = models.TextField(blank=True, null=True)
    tube = models.ForeignKey('TubeAnalyse', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'resultat'
        
        
class CanauxEmp(models.Model):
    id_med = models.ForeignKey(MedecinChef, models.DO_NOTHING, db_column='id_med', blank=True, null=True)
    id_inf = models.ForeignKey(Infirmier, models.DO_NOTHING, db_column='id_inf', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'canaux_emp'
        
        
class Discussion(models.Model):
    emetteur = models.CharField(max_length=11, blank=True, null=True)
    message = models.TextField(blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)
    id_canaux = models.ForeignKey(CanauxEmp, models.DO_NOTHING, db_column='id_canaux', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'discussion'