from django.contrib.auth.models import User
from django.db import models


class Exercise(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=200)
    sets = models.IntegerField(default=0)
    reps = models.CharField(max_length=200, default='0')
    timeUnderTension = models.IntegerField(default=0)
    weight = models.FloatField(default=0.0)
    machine = models.CharField(max_length=200, default='')
    rest = models.IntegerField(default=0)
    comment = models.CharField(max_length=200, default='')
    section = models.ForeignKey('Section', on_delete=models.CASCADE, related_name='exercises')


class Section(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=200)
    muscleGroup = models.CharField(max_length=200)
    workout = models.ForeignKey('Workout', on_delete=models.CASCADE, related_name='sections')


class Workout(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
