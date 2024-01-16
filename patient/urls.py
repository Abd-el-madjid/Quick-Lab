from django.urls import path
from . import views

urlpatterns = [
    path('', views.homepatient, name='homepatient'),
    path('account/', views.accountpatient, name='account'),
    path('updateforme/', views.accountpatient, name='updateforme'),
    path('changepassword/', views.accountpatient, name='changepassword'),
    path('deletacount/', views.accountpatient, name='deletacount'),
    path('updatedetail/', views.accountpatient, name='updatedetail'),
    path('book_appointment/', views.book_rdv, name='book_appointment'),
    path('get_analyse_branch/<int:id>/', views.analyse_labo, name='get_analyse_branch'),
    path('your_appointments/', views.your_rdv, name='your_appointments'),
    path('detaille_appointments/<int:id>/', views.dtl_rdv, name='detaille_appointments'),
    path('your_results/', views.result, name='your_results'),
    path('predection/', views.predection, name='predection'),
    path('channels_patient/', views.channels, name='channels_patient'),
    path('channels-data/', views.channels_data_view),
    path('channels_patient/messages/<int:id>/', views.messages_pat,name="message_patient"),
    path('messages_data/<int:id>/', views.messages_data),
    path('get_conseille/', views.get_conseille),
    path('get_prix/', views.get_prix),
    path('notification/', views.notification_patient,name="notification_patient"),
    path('logout/', views.signout, name='logout'),
]
