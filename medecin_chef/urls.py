from django.urls import path


from . import views

urlpatterns = [
    path('', views.homeinfirmier, name='homemedecinchef'),
    path('notification/', views.notification_medecin, name='notification_medecin'),
    path('account/', views.account_medecin, name='account_medecin'),
    path('results/', views.results, name='results'),
    path('results/rapport/<int:id>/', views.rapport, name='rapport'),
    path('results/rapport_donation/<int:id>/', views.rapport_donation, name='rapport_donation'),
    path('results/rapport/edit_rapport/<int:id>/', views.edit_rapport, name='edit_rapport'),
    path('results/rapport/edit_rapport_don/<int:id>/', views.edit_rapport_don, name='edit_rapport_don'),
    path('channels_med/', views.channels, name='channels_med'),
    path('channels-data/', views.channels_data_view),
    path('channels_med/messages/<int:id>/', views.messages_pat),
    path('messages_data/<int:id>/', views.messages_data),
    path('logout/', views.signout, name='logout'),
] 