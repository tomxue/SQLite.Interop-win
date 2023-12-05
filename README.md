# SQLite.Interop Packaging

This project builds SQLite.Interop.dll as platform specific binaries for `win-arm`, `win-arm64`, `win-x86` and `win-x64`.

The `package.ps1` script will build from the versioned source for [System.Data.SQLite](https://system.data.sqlite.org). See script for URL and SHA256.

The `test.ps1` script will use both `sqlite3` and `dotnet` to perform a test of the binary dll. `test.csproj` uses the [NuGet System.Data.SQLite.Core](https://www.nuget.org/packages/System.Data.SQLite.Core/) to compile. `test.ps1` uses [Precompiled Binaries for the .NET Standard 2.0](https://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki) to execute.

The project requires

- [Visual Studio 2022](https://visualstudio.microsoft.com/vs/), Community Edition is sufficient
- [PowerShell](https://github.com/PowerShell/PowerShell), tested with 7.4.0
- [.NET 6.0](https://dotnet.microsoft.com/en-us/download/dotnet/6.0), full SDK required

These scripts are licensed using [GPLv3](http://www.gnu.org/licenses). [SQLite is public domain](https://www.sqlite.org/copyright.html).

See also [SQLite](https://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki) and [.NET RID Catalog](https://learn.microsoft.com/en-us/dotnet/core/rid-catalog).

##

**tomxue：**

**Run script issue**:\
	The file package.ps1 is not digitally signed. You cannot run this script on the current system.
	
**Solution**:\
	powershell.exe -executionpolicy bypass -file .\package.ps1
	
<br />
<br />
	
**Compile issue**:\
	SQLite.Interop-win\src\SQLite.Interop\src\generic\../contrib/extension-functions.c(147): error C2371: 'int16_t': redefinition; different basic types
	C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.38.33130\include\stdint.h(19): note: see declaration of 'int16_t'
	SQLite.Interop-win\src\SQLite.Interop\src\generic\../contrib/extension-functions.c(148): error C2371: 'uint16_t': redefinition; different basic types
	C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.38.33130\include\stdint.h(23): note: see declaration of 'uint16_t'
	
**Solution**:\
	Modify file SQLite.Interop-win\src\SQLite.Interop\src\contrib\extension-functions.c, comment out line 147, 148
