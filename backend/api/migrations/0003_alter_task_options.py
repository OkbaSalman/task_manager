# Generated by Django 5.1.4 on 2024-12-23 15:14

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_rename_status_task_done'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='task',
            options={'ordering': ['-urgent', '-done']},
        ),
    ]