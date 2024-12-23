from django.db import models

# Create your models here.
class Task(models.Model):
    title = models.TextField()
    content = models.TextField()
    done = models.BooleanField(default=False)
    urgent = models.BooleanField(default=False)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    def __str__(self):
        return str({"title" : self.title,
                "content" : self.content,
                "done" : self.done,
                "urgent" : self.urgent})
    
    class Meta:
        ordering = ['-urgent','-done']
