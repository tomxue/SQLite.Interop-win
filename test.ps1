#!/usr/bin/env pwsh
#
#  Copyright 2022, Roger Brown
#
#  This file is part of rhubarb-geek-nz/SQLite.Interop.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#

$VERSION = "1.0.118.0"
$SHA256 = "21093E5FFA803009C6B02E5F5495B5E07971FD0371C667359960419068A432F2"
$ZIPNAME = "sqlite-netStandard20-binary-$VERSION.zip"
$TOOLS = "sqlite-tools-win32-x86-3400000"

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

trap
{
	throw $PSItem
}

foreach ($Name in "bin", "obj") {
	if (Test-Path "$Name") {
		Remove-Item "$Name" -Force -Recurse
	} 
}

Write-Host "tomxue             -8"
cmd /c 'pause'

& "dotnet.exe" build "test.csproj" --configuration Release

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}

Write-Host "tomxue             -7"
cmd /c 'pause'

If (-not(Test-Path "test.db"))
{
	Write-Host "Following should succeed and create a database"

	if (-not(Test-Path -Path "$TOOLS"))
	{
		if (-not(Test-Path -Path "$TOOLS.zip"))
		{
			Invoke-WebRequest -Uri "https://www.sqlite.org/2022/$TOOLS.zip" -OutFile "$TOOLS.zip"
		}

		Expand-Archive -Path "$TOOLS.zip" -DestinationPath .
	}

@"
CREATE TABLE MESSAGES (
	CONTENT VARCHAR(256)
);

INSERT INTO MESSAGES (CONTENT) VALUES ('Hello World');

SELECT * FROM MESSAGES;
"@ | & "$TOOLS\sqlite3.exe" test.db

	If ( $LastExitCode -ne 0 )
	{
		Exit $LastExitCode
	}
}

Write-Host "tomxue             -6"
cmd /c 'pause'

if (("$env:PROCESSOR_ARCHITECTURE" -eq "x86") -or ("$env:PROCESSOR_ARCHITECTURE" -eq "AMD64"))
{
	Write-Host "Following should succeed and read the database"

	& "dotnet.exe" "bin\Release\net6.0\test.dll"

	If ( $LastExitCode -ne 0 )
	{
		Exit $LastExitCode
	}
}

Write-Host "tomxue             -5"
cmd /c 'pause'

Remove-Item "bin\Release\net6.0\runtimes" -Force -Recurse

Write-Host "Following should fail with missing SQLite.Interop.dll"

& "dotnet.exe" "bin\Release\net6.0\test.dll"

Write-Host "tomxue             -4"
cmd /c 'pause'



if (-not(Test-Path "runtimes"))
{
	Write-Host "tomxue             -3"
	Expand-Archive -Path SQLite.Interop-$VERSION-win.zip -DestinationPath "."
}

Write-Host "tomxue             -2"
switch ( "$env:PROCESSOR_ARCHITECTURE" )
{
	"x86"   { Copy-Item -LiteralPath "runtimes\win-x86\native\SQLite.Interop.dll"   -Destination "bin\Release\net6.0" }
	"AMD64" { Copy-Item -LiteralPath "runtimes\win-x64\native\SQLite.Interop.dll"   -Destination "bin\Release\net6.0" }
	"ARM"   { Copy-Item -LiteralPath "runtimes\win-arm\native\SQLite.Interop.dll"   -Destination "bin\Release\net6.0" }
	"ARM64" { Copy-Item -LiteralPath "runtimes\win-arm64\native\SQLite.Interop.dll" -Destination "bin\Release\net6.0" }
	default { throw "Unknown architecure" }
}

cmd /c 'pause'

Write-Host "Following should fail with missing entry point SI7fca2652f71267db in SQLite.Interop.dll"

& "dotnet.exe" "bin\Release\net6.0\test.dll"
Write-Host "tomxue             -1"



if (-not(Test-Path -Path $ZIPNAME))
{
	Write-Host "tomxue             2"
	Invoke-WebRequest -Uri "https://system.data.sqlite.org/blobs/$VERSION/$ZIPNAME" -OutFile $ZIPNAME
}

Write-Host "tomxue             3"
Remove-Item "bin\Release\net6.0\System.Data.SQLite.dll"
Write-Host "tomxue             4"

$null = New-Item -Path "." -Name "tmp" -ItemType "directory"
cmd /c 'pause'
Write-Host "tomxue             5"

try
{
	Expand-Archive -LiteralPath "$ZIPNAME" -DestinationPath "tmp"

	if ((Get-FileHash -LiteralPath $ZIPNAME -Algorithm "SHA256").Hash -ne $SHA256)
	{
		throw "SHA256 mismatch for $ZIPNAME"
	}


	cmd /c 'pause'
	Write-Host "tomxue             6"
	$null = Move-Item -Path "tmp\System.Data.SQLite.dll" -Destination "bin\Release\net6.0"
}
finally
{
	cmd /c 'pause'
	Write-Host "tomxue             7"
	Remove-Item "tmp" -Force -Recurse
}

Write-Host "Following should succeed and read the database"

& "dotnet.exe" "bin\Release\net6.0\test.dll"

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}

Write-Host "Tests complete"
