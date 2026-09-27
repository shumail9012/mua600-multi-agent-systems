Program sMove;

function onRun() : integer;
var srcX, dstX : integer;
var arrived : boolean;
begin
    srcX := interface.sourceX;
    dstX := interface.destX;
    
    writeln('Crane: Starting move. Pick from X=', srcX, ' Place at X=', dstX);
    
    (* Step 1: Release vacuum *)
    agent.vacuum := 0;
    Sleep(300);
    
    (* Step 2: Rise to travel height Y=200 *)
    agent.setY := 200;
    arrived := false;
    while not arrived do begin
        if abs(agent.posY - 200) < 10 then
            arrived := true;
        Sleep(100);
    end;
    
    (* Step 3: Move in X to source position *)
    agent.setX := srcX;
    arrived := false;
    while not arrived do begin
        if abs(agent.posX - srcX) < 10 then
            arrived := true;
        Sleep(100);
    end;
    
    (* Step 4: Descend to pick height Y=82 *)
    agent.setY := 82;
    arrived := false;
    while not arrived do begin
        if abs(agent.posY - 82) < 10 then
            arrived := true;
        Sleep(100);
    end;
    
    (* Step 5: Grip the part *)
    agent.vacuum := 1;
    Sleep(500);
    
    (* Step 6: Rise back to travel height *)
    agent.setY := 200;
    arrived := false;
    while not arrived do begin
        if abs(agent.posY - 200) < 10 then
            arrived := true;
        Sleep(100);
    end;
    
    (* Step 7: Move in X to destination position *)
    agent.setX := dstX;
    arrived := false;
    while not arrived do begin
        if abs(agent.posX - dstX) < 10 then
            arrived := true;
        Sleep(100);
    end;
    
    (* Step 8: Descend to place height Y=82 *)
    agent.setY := 82;
    arrived := false;
    while not arrived do begin
        if abs(agent.posY - 82) < 10 then
            arrived := true;
        Sleep(100);
    end;
    
    (* Step 9: Release part *)
    agent.vacuum := 0;
    Sleep(300);
    
    (* Step 10: Rise back to travel height *)
    agent.setY := 200;
    arrived := false;
    while not arrived do begin
        if abs(agent.posY - 200) < 10 then
            arrived := true;
        Sleep(100);
    end;
    
    writeln('Crane: Move complete');
    onRun := processplan.done;
end.
