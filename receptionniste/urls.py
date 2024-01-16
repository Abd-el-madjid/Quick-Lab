from django.urls import path
from . import views

urlpatterns = [
    path('', views.homereceptionniste, name='homereceptionniste'),
    path('notification/', views.notification_receptioniste, name='notification_receptioniste'),
    path('account/', views.account_rec, name='account_rec'),
    path('appointment/', views.appointment, name='appointment'),
    path('appointment/addappointment/', views.add_appointment, name='addappointment'),
    path('card_pay',views.card_pay, name='card_pay'),
    path('ocr/', views.ocr, name='ocr'),
    path('results/', views.result, name='results_res'),
    path('channels_receptionniste/', views.channels, name='channels_receptionniste'),
    path('channels-data/', views.channels_data_view),
    path('channels_receptionniste/messages/<int:id>/', views.messages_res),
    path('messages_data/<int:id>/', views.messages_data),
    path('logout/', views.signout, name='logout'),
]