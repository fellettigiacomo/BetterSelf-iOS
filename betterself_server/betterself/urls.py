from rest_framework import routers

from betterself.views import WorkoutViewSet

router = routers.SimpleRouter()
router.register('workouts', WorkoutViewSet)

urlpatterns = [
    *router.urls
]
