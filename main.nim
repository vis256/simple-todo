import jester, strutils, sequtils, asyncdispatch, times, templates, json, algorithm
import styles, script


type todoItem = object
    id: int
    text: string
    dueDate: DateTime

var
    highestId = 0
    todoSeq: seq[todoItem]


proc addTodo(id: int, desc: string, date: DateTime): todoItem =
    result.id = id
    result.text = desc
    result.dueDate = date


proc loadTodosFromFile =
    let 
        fileData = readFile("todos.txt")
        contentSeq = fileData.splitLines()
    # echo contentSeq
    for line in contentSeq:
        # echo line
        if line == "": continue
        var 
            todoData = line.strip().split()
            descLen = len(todoData)
            desc = ""
        for i in 1..descLen-3:
            if todoData[i] != "" and todoData[i] != " ": desc = desc & ' ' & todoData[i]
        todoSeq.add addTodo(parseInt(todoData[0]), desc, parse(todoData[descLen-2] & " " & todoData[descLen-1], "YYYY-MM-dd HH:mm"))
        if parseInt(todoData[0]) > highestId: highestId = parseInt(todoData[0])

proc saveTodosToFile =
    var dataToWrite = ""
    for seqelem in todoSeq:
        # echo seqelem
        dataToWrite = dataToWrite &  $seqelem.id & " " & seqelem.text & " " & seqelem.dueDate.format("YYYY-MM-dd HH:mm") & "\n"
    writeFile("todos.txt", dataToWrite)

proc calcDateDiff(due: DateTime): string =
    var diff = due - times.now()
    if diff.inMinutes < 0: result = "<span class=\"dueDateText redContainer\">late by %%% hours</span>".replace("%%%", $abs(diff.inHours))
    elif diff.inMinutes < 60: result = "<span class=\"dueDateText orangeContainer\">in %%% minutes</span>".replace("%%%", $abs(diff.inMinutes))
    elif diff.inHours < 24: result = "<span class=\"dueDateText turquoiseContainer\">in %%% hours</span>".replace("%%%", $abs(diff.inHours))
    elif diff.inDays < 7: result = "<span class=\"dueDateText blueContainer\">in %%% days</span>".replace("%%%", $abs(diff.inDays))
    else: result = "<span class=\"dueDateText greenContainer\">in %%% days</span>".replace("%%%", $abs(diff.inDays))

proc cmpDate(x, y: todoItem): int = 
    var diff = (x.dueDate - y.dueDate).inSeconds
    if diff < 0: -1
    elif diff == 0: 0
    else: 1


proc renderPage(stylesheet, script: string): string = tmpli html"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
            <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/dark.css">
            <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>  
            <style>
            $stylesheet
            </style>
        </head>
        <body>
            <div class="note-elem">
                <h1>+</h1>
                <textarea autofocus id="text" class="inputfield" placeholder="your task"></textarea>
                <input id="flatpickr" class="inputfield" placeholder="task date">
            </div>
            $for item in todoSeq {
                <div id="note-$(item.id)" class="note-elem">
                    <button onClick="deleteItem($(item.id))">X</button>
                    <textarea disabled class="todoText">$(item.text)</textarea>
                    $( $calcDateDiff(item.dueDate) )
                </div>
            }
        <script>
        $script
        </script>
        </body>
        </html>
    """
# =====================

loadTodosFromFile()
# saveTodosToFile()

# Routes
routes:
    get "/": resp renderPage(styles(), script())

    post "/deleteItem":
        # echo request
        var reqID = parseJson(request.body).getOrDefault("id").getInt()
        todoSeq = filter(todoSeq, proc(x:todoItem): bool = x.id != reqID)
        resp Http200

    post "/addItem":
        var 
            rawJSON = parseJson(request.body)
            todoDesc = rawJSON.getOrDefault("desc").getStr()
            todoDate = rawJSON.getOrDefault("date").getStr()
            parsedTodoDate = parse(todoDate, "YYYY-MM-dd HH:mm")
        inc highestId
        todoSeq.add addTodo(highestId, todoDesc, parsedTodoDate)
        todoSeq.sort(cmpDate)
        saveTodosToFile()
        resp Http200

runForever()