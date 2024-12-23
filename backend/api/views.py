from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import TaskSerializer
from .models import Task


@api_view(['GET'])
def getRoutes(request):
    routes = [{
        'Endpoint' : '/tasks/',
        'method' : 'GET',
        'body' : None,
        'description' : 'returns an array of tasks'
    },{
        'Endpoint' : '/tasks/id',
        'method' : 'GET',
        'body' : None,
        'description' : 'returns a single task'
    },{
        'Endpoint' : '/tasks/create',
        'method' : 'POST',
        'body' : {'title' : "",
                  'content' : "",
                  "done" : "true/false",
                  "urgent" : "true/false"},
        'description' : 'creates a new task'
    },{
        'Endpoint' : '/tasks/id/update',
        'method' : 'PUT',
        'body' : {'title' : "",
                  'content' : "",
                  "done" : "true/false",
                  "urgent" : "true/false"},
        'description' : 'update an existing task'
    },{
        'Endpoint' : '/tasks/id/delete',
        'method' : 'DELETE',
        'body' : None,
        'description' : 'deletes an existing task'
    },]
    return Response(routes)


@api_view(['GET'])
def getTasks(request):
    tasks = Task.objects.all()
    serializer = TaskSerializer(tasks, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def getTask(request, pk):
    task = Task.objects.get(id=pk)
    serializer = TaskSerializer(task, many=False)
    return Response(serializer.data)


@api_view(['POST'])
def createTask(request):
    data = request.data
    task = Task.objects.create(
        title=data['title'],
        content=data['content'],
        urgent=data['urgent']
    )
    serializer = TaskSerializer(task, many=False)
    return Response(serializer.data)


@api_view(['PUT'])
def updateTask(request, pk):
    data = request.data
    task = Task.objects.get(id=pk)
    serializer = TaskSerializer(task, data=request.data)
    if serializer.is_valid():
        serializer.save()
    return Response(serializer.data)


@api_view(['DELETE'])
def deleteTask(request,pk):
    task = Task.objects.get(id=pk)
    task.delete()
    return Response("Task was deleted!")