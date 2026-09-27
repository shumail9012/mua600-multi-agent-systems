program Source2;

var deployed : boolean;

procedure onDeploy;
begin
    deployed := false;
    agent.locationX := 158;
    writeln('Source2: Ready. locationX=', agent.locationX);
end.

procedure Running;
begin
    Sleep(500);
    if agent.sensor = 0 then begin
        deployed := false;
    end;
    if (agent.sensor = 1) and (not deployed) then begin
        writeln('Source2: Part detected. Deploying Part2...');
        Sleep(500);
        if deploybyname('Part2') then begin
            deployed := true;
            writeln('Source2: Part2 deployed');
        end;
    end;
end.
