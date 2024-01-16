from django.contrib import admin
from django.urls import path, include, re_path
from django.conf import settings
from django.conf.urls.static import static
from django.views.static import serve
from django.views.generic import TemplateView



urlpatterns = [
    path('',include('accueill.urls')),
    path('login/',include('login.urls')),
    path('admin/',include('admin.urls')),
    path('patient/', include('patient.urls')),
    path('directeur/', include('directeur.urls')),
    path('receptionniste/', include('receptionniste.urls')),
    path('infirmier/', include('infirmier.urls')),
    path('medecin_chef/', include('medecin_chef.urls')),
    path('.well-known/pki-validation/799C0DD3731D38E1848DBE3EC75A336B.txt', TemplateView.as_view(template_name='pki-validation.txt')),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
urlpatterns += static(settings.SPECIAL_MEDIA_URL, document_root=settings.SPECIAL_MEDIA_ROOT)
