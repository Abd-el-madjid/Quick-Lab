
import os
from celery import Celery

# Set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'quick_lab.settings')

# Create the Celery application instance.
app = Celery('your_project')

# Load configuration from Django settings.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Discover tasks in all installed apps.
app.autodiscover_tasks()