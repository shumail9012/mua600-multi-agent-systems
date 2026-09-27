function onRun() : integer;
begin
    writeln('Process2: Waiting for part on sensor2...');
    while agent.sensor2 = 0 do
        Sleep(100);   // Wait for part at Process2 only

    // Crane retract time
    Sleep(500);

    writeln('Process2: Starting...');
    agent.run := 1;

    // Wait until machine actually starts
    while agent.isRunning = 0 do
        Sleep(100);

    writeln('Process2: Running...');
    agent.run := 0;

    // Wait until machine finishes
    while agent.isRunning = 1 do
        Sleep(100);

    writeln('Process2: Done.');
    onRun := processplan.done;
end.
