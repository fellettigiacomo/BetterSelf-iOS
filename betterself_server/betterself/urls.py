from django.urls import path
from rest_framework import routers

from betterself.views import WorkoutViewSet, LoginView

router = routers.SimpleRouter()
router.register('workouts', WorkoutViewSet)

urlpatterns = [
    *router.urls,
    path('login/', LoginView.as_view(), name='login')
]
