# Generated by Django 4.2 on 2023-06-07 23:03

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Notification',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateTimeField(blank=True, null=True)),
                ('contenu', models.TextField(blank=True, null=True)),
                ('is_read', models.IntegerField(blank=True, null=True)),
            ],
            options={
                'db_table': 'notification',
                'managed': False,
            },
        ),
    ]
