# Generated by Django 4.2 on 2023-06-01 18:12

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('directeur', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='AnalyseChamp',
            fields=[
                ('code', models.OneToOneField(db_column='code', on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='directeur.typeanalyse')),
                ('champ_name', models.TextField(blank=True, null=True)),
                ('units', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': 'analyse_champ',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Resultat',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('resultat', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': 'resultat',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='TubeAnalyse',
            fields=[
                ('id', models.IntegerField(primary_key=True, serialize=False)),
                ('is_done', models.IntegerField(blank=True, null=True)),
            ],
            options={
                'db_table': 'tube_analyse',
                'managed': False,
            },
        ),
    ]
