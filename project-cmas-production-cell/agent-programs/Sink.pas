program Sink;

var count : integer;

procedure onDeploy;
begin
    count := 0;
    agent.locationX := 945;
    writeln('Sink: Ready. locationX=', agent.locationX);
end.
