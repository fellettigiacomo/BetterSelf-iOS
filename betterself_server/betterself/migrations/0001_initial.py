# Generated by Django 5.0.6 on 2024-06-02 21:28

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name="Section",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=200)),
                ("muscleGroup", models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name="Exercise",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=200)),
                ("sets", models.IntegerField(default=0)),
                ("reps", models.CharField(default="0", max_length=200)),
                ("timeUnderTension", models.IntegerField(default=0)),
                ("weight", models.FloatField(default=0.0)),
                ("machine", models.CharField(default="", max_length=200)),
                ("rest", models.IntegerField(default=0)),
                ("comment", models.CharField(default="", max_length=200)),
                (
                    "section",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="betterself.section",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Workout",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="section",
            name="workout",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="betterself.workout"
            ),
        ),
    ]
