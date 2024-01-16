from django.urls import path
from . import views

urlpatterns = [
    path('', views.homedirecteur, name='homedirecteur'),
    path('account/', views.account_directeur, name='account_directeur'),
    path('notification/', views.notification_directeur, name='notification_directeur'),
    path('gestionemp/', views.gestionemp, name='gestionemp'),
    path('gestionemp/addemp/', views.addemp, name='addemp'),
    path('gestanalyse/', views.gestanalyse, name='gestanalyse'),
    path('gestanalyse/addanalyse/', views.addanalyse, name='addanalyse'),
    path('gestbranch/', views.gestbranch, name='gestbranch'),
    path('gestbranch/addbranch/', views.addbranch, name='addbranch'),
    path('gestionemp/getinfo/<int:id>', views.editemp, name='getinfo'),
    path('gestclient/', views.gestclient, name='gestclient'),
    path('reclamation/', views.reclamation, name='reclamation'),
    path('blood_bank/', views.blood_bank, name='blood_bank'),
    path('statistique/', views.statdirecteur, name='statistique'),
    path('logout/', views.signout, name='logout'),
]