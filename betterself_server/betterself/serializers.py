from django.contrib.auth.models import User
from rest_framework import serializers

from betterself.models import Workout, Section, Exercise


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('username', 'email')


class ExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Exercise
        fields = ('id', 'name', 'sets', 'reps', 'timeUnderTension', 'weight', 'machine', 'rest', 'comment')


class SectionSerializer(serializers.ModelSerializer):
    exercises = ExerciseSerializer(many=True)

    class Meta:
        model = Section
        fields = ('id', 'name', 'muscleGroup', 'exercises')


class WorkoutSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    sections = SectionSerializer(many=True)

    class Meta:
        model = Workout
        fields = ('id', 'user', 'sections')
