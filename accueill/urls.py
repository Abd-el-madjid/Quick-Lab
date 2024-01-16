from login.views import appointment_detail
from . import views
from django.urls import path

urlpatterns = [
    path('', views.home,name='home'), 
    path('history/', views.history,name='history'), 
    path('about-us/', views.about_us,name='about-us'), 
    path('lab_detaille/<int:id>/', views.lab_detaille, name='lab_detaille'), 
    path('laboratoire-list/', views.laboratoire_list,name='laboratoire-list'), 
    path('privecy/', views.privecy,name='privecy'), 
    path('term/', views.term,name='term'), 
    path('book-appointment/', views.book_appointment, name='book_appointment'),
    path('check-patient/', views.check_patient, name='check_patient'),
    path('lab_detaille/<int:id>/', views.lab_detaille, name='lab_detaille'),
    path('notification/', views.notification_data, name='notification'),
    path('show_all_notification/', views.show_all_notification, name='show_all_notification'),
    path('account_all/', views.account_all, name='account_all'),
    path('appointments/<str:encrypted_id>/', appointment_detail, name='appointment_detail'),
]
