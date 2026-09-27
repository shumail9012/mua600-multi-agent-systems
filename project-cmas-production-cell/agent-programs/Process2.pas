program Process2;

procedure onDeploy;
begin
    agent.run := 0;
    agent.locationX := 650;   // Example: Process2 is further right
    writeln('Process2: Ready. locationX=', agent.locationX);
end.
