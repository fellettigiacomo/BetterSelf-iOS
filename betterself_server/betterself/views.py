from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from betterself.models import Workout
from betterself.serializers import WorkoutSerializer


class WorkoutViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = Workout.objects.all()
    serializer_class = WorkoutSerializer

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)
