function onRun() : integer;
begin
    writeln('Process1: Waiting for part on sensor1...');
    while agent.sensor1 = 0 do
        Sleep(100);   // Wait for part at Process1 only

    // Crane retract time
    Sleep(500);

    writeln('Process1: Starting...');
    agent.run := 1;

    // Wait until machine actually starts
    while agent.isRunning = 0 do
        Sleep(100);

    writeln('Process1: Running...');
    agent.run := 0;

    // Wait until machine finishes
    while agent.isRunning = 1 do
        Sleep(100);

    writeln('Process1: Done.');
    onRun := processplan.done;
end.
