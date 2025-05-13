from fastapi import FastAPI, HTTPException
from models import Task, TaskWithID, UpdateTask
from operations import read_all_tasks, read_task, create_task, modify_task, remove_task

app = FastAPI()


@app.get("/tasks", response_model=list[TaskWithID])
def get_tasks():
    return read_all_tasks()


@app.get("/tasks/{task_id}", response_model=TaskWithID)
def get_task(task_id: int):
    task = read_task(task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task


@app.post("/tasks", response_model=TaskWithID)
def add_task(task: Task):
    return create_task(task)


@app.put("/tasks/{task_id}", response_model=TaskWithID)
def update_task(task_id: int, task_update: UpdateTask):
    updated_task = modify_task(task_id, task_update.model_dump(exclude_unset=True))
    if not updated_task:
        raise HTTPException(status_code=404, detail="Task not found")
    return updated_task


@app.delete("/tasks/{task_id}", response_model=Task)
def delete_task(task_id: int):
    removed_task = remove_task(task_id)
    if not removed_task:
        raise HTTPException(status_code=404, detail="Task not found")
    return removed_task
