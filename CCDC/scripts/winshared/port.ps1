$mode = $args[0]
$target = $args[1]



function main() {
    if ($mode -eq $null) {
    "No mode was selected"
    exit
    } ElseIf ($target -eq $null) {
    "No IP or range was entered"
    exit
    } ElseIf ($mode -eq 1) {
    singleHost
    } Elseif ($mode -eq 2) {
    range
    } Else {
    "Please Input either mode: 1 or 2"
    exit    
    }
}


function singleHost() {
"Scanning first 1024 ports on " + $target + "!"
1..1024 | % {echo ((new-object Net.Sockets.TcpClient).Connect("$target",$_)) "Port $_ is open!"} 2>$null
}

#remember to change for range
function range() {
"Scanning first 1024 ports on " + $target + " range!"
$target | % { $a = $_; 1..1024 | % {echo ((new-object Net.Sockets.TcpClient).Connect("10.0.0.$a",$_)) "Port $_ is open!"} 2>$null}
}

main
