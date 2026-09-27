Program sArrive;

function onRun() : integer;
begin
    writeln('Sink: Part arrived! Journey complete.');
    onRun := processplan.done;
end.
