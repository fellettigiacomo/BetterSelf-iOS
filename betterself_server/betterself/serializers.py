from rest_framework import serializers

from betterself.models import Workout, Section, Exercise


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
    sections = SectionSerializer(many=True)

    class Meta:
        model = Workout
        fields = ('id', 'sections')


class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=255)
    password = serializers.CharField(write_only=True)
