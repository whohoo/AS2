rem set the as2api.exe path.
set exeDirectory=F:\software\flashœ‡πÿ\as2doc\as2api

rem set params
set output="./main"
set classpath="./classes"
set title="whohoo AS2 documents"
set encoding="UTF-8"
set package="com.*"

rem make a diagrams graphics
set diagrams=--draw-diagrams --dot-exe "D:\Program Files\ATT\Graphviz\bin\dot.exe"

%exeDirectory%\as2api.exe -d %output% --classpath %classpath% --title %title% --progress --encoding %encoding% %diagrams% %package%

