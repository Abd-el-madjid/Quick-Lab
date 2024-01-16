from django.urls import path
from . import views

urlpatterns = [
    path('', views.homeinfirmier, name='homeinfirmier'),
    path('notification/', views.notification_infermieur, name='notification_infermieur'),
    path('account/', views.account_infermieur, name='account_infermieur'),
    path('liste_appointments/', views.appointment_liste, name='liste_appointments'),
    path('liste_appointments/detaille/<int:id>/', views.Appointment_detaille, name='Appointment_detaille'),
    path('add_tube_analyse/', views.add_tube_analyse, name='add_tube_analyse'),
    path('done_analyse/', views.done_analyse, name='done_analyse'),
    path('results/', views.result, name='results_inf'),
    path('results/fill_result/<int:id>/', views.fill_result, name='fill_result'),
    path('channels_inf/', views.channels, name='channels_inf'),
    path('channels-data/', views.channels_data_view),
    path('channels_inf/messages/<int:id>/', views.messages_pat),
    path('messages_data/<int:id>/', views.messages_data),
    path('logout/', views.signout, name='logout'),
]