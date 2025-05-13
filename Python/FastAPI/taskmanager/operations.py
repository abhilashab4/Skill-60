import csv
from models import Task, TaskWithID

DATABASE_FILENAME = "tasks.csv"
column_fields = ["id", "title", "description", "status"]


def read_all_tasks() -> list[TaskWithID]:
    with open(DATABASE_FILENAME, newline="") as csvfile:
        reader = csv.DictReader(csvfile) 
        return [TaskWithID(**row) for row in reader]

def read_task(task_id: int) -> TaskWithID | None:
    with open(DATABASE_FILENAME, newline="") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if int(row["id"]) == task_id:
                return TaskWithID(**row)
    return None


def get_next_id() -> int:
    try:
        with open(DATABASE_FILENAME, "r", newline="") as csvfile:
            reader = csv.DictReader(csvfile)
            max_id = max(int(row["id"]) for row in reader)
            return max_id + 1
    except (FileNotFoundError, ValueError):
        return 1


import os
def write_task_into_csv(task: TaskWithID):
    file_exists = os.path.isfile(DATABASE_FILENAME)

    with open(DATABASE_FILENAME, mode="a", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=column_fields)
        
        # Write header only if file is empty
        if not file_exists or os.stat(DATABASE_FILENAME).st_size == 0:
            writer.writeheader()

        data = task.model_dump()
        print("Writing:", data)  
        writer.writerow(data)



def create_task(task: Task) -> TaskWithID:
    id = get_next_id()
    task_with_id = TaskWithID(id=id, **task.model_dump())
    write_task_into_csv(task_with_id)
    return task_with_id


def modify_task(id: int, task: dict) -> TaskWithID | None:
    updated_task: TaskWithID | None = None
    tasks = read_all_tasks()

    for index, task_obj in enumerate(tasks):
        if int(task_obj.id) == id:
            updated_task = task_obj.model_copy(update=task)
            tasks[index] = updated_task
            break

    with open(DATABASE_FILENAME, mode="w", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=column_fields)
        writer.writeheader()
        for task in tasks:
            writer.writerow(task.model_dump())

    return updated_task


def remove_task(id: int) -> Task | None:
    deleted_task: TaskWithID | None = None
    tasks = read_all_tasks()

    with open(DATABASE_FILENAME, mode="w", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=column_fields)
        writer.writeheader()
        for task in tasks:
            if int(task.id) == id:
                deleted_task = task
                continue
            writer.writerow(task.model_dump())

    if deleted_task:
        task_dict = deleted_task.model_dump()
        del task_dict["id"]
        return Task(**task_dict)

    return None
