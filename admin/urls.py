from . import views
from django.urls import path

urlpatterns = [
    path('', views.admin_login, name='admin_login'),
    path('lab_management/', views.lab_management, name='lab_management'),
    path('lab_management/add_lab/', views.add_lab, name='add_lab'),
    
    path('validation/', views.validation, name='validation'),
    path('statistique/', views.statistique, name='statistique_admin'),
    path('admin_logout/', views.admin_logout, name='admin_logout'),
    # Other URL patterns for your project
]
