program Process1;

procedure onDeploy;
begin
    agent.run := 0;
    agent.locationX := 450;
    writeln('Process1: Ready. locationX=', agent.locationX);
end.
