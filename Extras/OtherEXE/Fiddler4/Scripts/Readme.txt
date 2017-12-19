Thanks for downloading the Fiddler Request To Code extension!
You can always find the latest version at: http://www.chadsowald.com/software/fiddler-extension-request-to-code or http://www.chadsowald.com


HOW TO USE:

################# Fiddler Request To Code ################################
FiddlerRequestToCode.dll
- This is the actual Fiddler application extension.
- Copy this file to either of the Fiddler2\Scripts directory locations and restart Fiddler if it was already running:
	- C:\Program Files (x86)\Fiddler2\Scripts  or
	- C:\<path to user my documents>\Fiddler2\Scripts
- Now you can use the newly added "Code" tab in Fiddler.
- There are many distributions of Python available if you want to use the "Run" feature when you have Python selected in the Code tab.
	- http://www.python.org/getit/ has many links.  This extension was tested against IronPython 2.7.3 and Python 3.2.3

################# FiddlerCore Request To Code ################################
This version of the Request To Code extension is built for FiddlerCore (the library) rather than Fiddler (the application).
These files are located in the "FiddlerCore Compatible" folder.  Use them instead of the normal extension file:
FiddlerCoreRequestToCode.dll
FiddlerCoreRequestToCode.xml
- Reference the .dll file in your .NET project along with the FiddlerCore library - http://fiddler2.com/Fiddler/Core/

A brief code example if you're using the FiddlerCoreRequestToCode.dll:

************************************************************
using System.IO;
using System.Net;
using Fiddler;
using FiddlerCoreRequestToCode;
...
...
...
private void RecordCodeForUrl()
{
	//Start Fiddler on an available port.
	FiddlerApplication.Startup(6575, true, true);

	var codeGenerator = new CodeGenerator(new CSharpLanguage()) { ShowUsage = true, ShowComments = true };

	//For each request...
	FiddlerApplication.BeforeRequest += (session) =>
	{
		string code;
		if (codeGenerator.TryGenerateCode(new[] { session }, out code))
		{
			//You'll need to make the file path unique
			File.WriteAllText(Environment.CurrentDirectory + "/" + "request.cs", code);
		}
	};

	//You'll probably have another way of creating the traffic to be recorded.
	//This is just an example.
	var request = WebRequest.Create("http://fiddler2.com/fiddler2/");
	var response = request.GetResponse();
	using (var reader = new StreamReader(response.GetResponseStream()))
	{
		string html = reader.ReadToEnd();
	}
	response.Close();

	//Stop Fiddler.
	FiddlerApplication.Shutdown();
}