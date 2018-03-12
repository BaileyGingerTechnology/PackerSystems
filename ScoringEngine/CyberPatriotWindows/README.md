# Windows Scoring Engine

(And probably going to become the *Nix scoring engine too)

## How it will work, in theory:

Using the Microsoft.Extensions.Configuration.Json NuGet package, I can have a dotnet console app get info from a JSON file pretty easily. That should make it pretty simple to have a
JSON config file that allows for easy checks to be built out. Then it's just a matter of getting the program to actually run them on a schedule, and have the player be able to request
that a check be run.

Inspired by how a Packer provisioner works, I want to try something like having the checker take input from the JSON file, run inline commands or executes programs that it gives,
receive a 1 or a 0 exit code, and then depending on that output info on the check if it returned positive. I am very far off from this though and should probably make a more
basic system in the meantime.