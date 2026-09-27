program Source1;


var partDeployed : boolean;

procedure Running;
begin
    if agent.sensor = 0 then begin
        partDeployed := false;
    end;
    else if (agent.sensor = 1) and (not partDeployed) then begin
        writeln('Source1: Part detected! Deploying Part1...');
        if not deploybyname('Part1') then begin
            writeln('Source1: ERROR - Could not deploy Part1');
        end;
        partDeployed := true;
    end;
    Sleep(200);
end.

procedure onDeploy;
begin
    partDeployed := false;
end.
