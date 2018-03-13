using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

using Microsoft.Extensions.Configuration;

using Newtonsoft.Json;

public class Program
{
  public static IConfiguration Configuration { get; set; }
  public static string Config = "";

  public static void Main(string[] args = null)
  {
    var builder = new ConfigurationBuilder()
      .AddCommandLine(args)
      .Build();

    Config = builder["BuildFor"] + ".json";
    
    var config = new ConfigurationBuilder()
      .SetBasePath(Directory.GetCurrentDirectory())
      .AddJsonFile(builder["BuildFor"] + ".json", optional: false, reloadOnChange: true)
      .AddEnvironmentVariables()
      .AddCommandLine(args);
    
    Configuration = config.Build();
    
    Console.WriteLine($"Checking for: {Configuration["Machine"]}");
    Console.WriteLine($"Check version: {Configuration["Version"]}");
    Console.WriteLine();

    Console.WriteLine("Running checks");
    
    Console.WriteLine($"Checks: {Configuration["Checks:1:type"]}");
  }

  private static void RunCheckWindows(string type, string script)
  {
    
  }
}