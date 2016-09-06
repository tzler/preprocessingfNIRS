function upData = updateRecord(data, name, info, results)
try 
    newTask = length(data.record) + 1; 
    update.name = name; 
    update.parameters =  info;
    update.results = results; 
    data.record(newTask) = update;
catch 
    update.name = name; 
    update.parameters = info; 
    update.results = results; 
    data.record(1) = update; 
end 
upData = data; 
end 