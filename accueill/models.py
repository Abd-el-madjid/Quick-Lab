from django.db import models

from login.models import Personne

class Notification(models.Model):
    date = models.DateTimeField(blank=True, null=True)
    contenu = models.TextField(blank=True, null=True)
    id_prs = models.ForeignKey(Personne, models.DO_NOTHING, db_column='id_prs', blank=True, null=True)
    is_read = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'notification'