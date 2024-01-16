from . import views
from django.urls import path

urlpatterns = [
    path('', views.signin, name='signin'), 
    path('signup', views.registration, name='signup'),
    path('verify-code/', views.verify_code, name='verify_code'),
    path('signup_labo/', views.signup_labo, name='signup_labo'), 
    path('activate/<uidb64>/<token>', views.activate, name='activate'),
    path('Forgot_Password', views.forgot_password, name="Forgot_Password"), 
    path('reset_password/<uidb64>/<token>/', views.reset_password, name='reset_password'),
    path('accounts/login/', views.signin, name='login'),
    path('payment/<uidb64>/<token>/', views.payment, name='payment'),

]
