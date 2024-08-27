from django.contrib import admin

from betterself.models import Exercise, Section, Workout


@admin.register(Exercise)
class ExerciseAdmin(admin.ModelAdmin):
    list_display = ('name', 'sets', 'reps', 'timeUnderTension', 'weight', 'machine', 'rest', 'comment', 'section')


@admin.register(Section)
class SectionAdmin(admin.ModelAdmin):
    list_display = ('name', 'muscleGroup', 'workout')


@admin.register(Workout)
class WorkoutAdmin(admin.ModelAdmin):
    list_display = ('user',)
