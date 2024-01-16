from django.contrib.auth.backends import ModelBackend
from .models import Admin

class AdminBackend(ModelBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            admin = Admin.objects.get(email=username)

            if admin.mot_de_pass == password:
                return admin

        except Admin.DoesNotExist:
            return None

    def get_user(self, user_id):
        try:
            return Admin.objects.get(pk=user_id)

        except Admin.DoesNotExist:
            return None
