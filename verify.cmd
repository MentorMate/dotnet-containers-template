REM cspell: ignore markdownlint, gitleaks, mkdir, pushd, popd, xvzf
CALL ^
powershell -command "If(!(Test-Path '.tools')){ New-Item -ItemType directory -Path .tools }" &&^
powershell -command "If(!(Test-Path '.tools\gitleaks.exe')) { ([System.Net.WebClient]::new()).DownloadFile('https://github.com/zricethezav/gitleaks/releases/download/v8.2.7/gitleaks_8.2.7_windows_x64.zip', '.tools\gitleaks.zip'); Expand-Archive -Force '.tools\gitleaks.zip' '.tools' }" &&^
powershell -command "If(!(Test-Path '.tools\bin\ec-windows-amd64.exe')) { ([System.Net.WebClient]::new()).DownloadFile('https://github.com/editorconfig-checker/editorconfig-checker/releases/download/2.4.0/ec-windows-amd64.exe.tar.gz', '.tools\editorconfig.tar.gz'); pushd .tools; & tar.exe -xvzf editorconfig.tar.gz; popd; }" &&^
echo ***** git-leaks ***** &&^
.tools\gitleaks.exe detect &&^
echo ***** editorconfig checker ***** &&^
.tools\bin\ec-windows-amd64.exe &&^
echo ***** cspell ***** &&^
npx cspell --no-progress "**/*" &&^
echo ***** markdown lint ***** &&^
npx markdownlint-cli **/*.md --ignore **/node_modules/** &&^
echo ***** dotnet format ***** &&^
dotnet format whitespace --verify-no-changes &&^
dotnet format style --verify-no-changes &&^
echo ***** web lint ***** &&^
npm run lint --prefix ./src/Calculator.Web/calculator-app &&^
echo ***** web tests ***** &&^
npm run test --prefix ./src/Calculator.Web/calculator-app &&^
echo ***** build all ***** &&^
dotnet build &&^
echo ***** api tests ***** &&^
dotnet test src/Calculator.Services.ArithmeticOperations.Tests/Calculator.Services.ArithmeticOperations.Tests.csproj &&^
echo ***** verify bicep ***** &&^
echo Node: run 'az bicep install' before that &&^
az bicep build -f .github/biceps/main.bicep -o none &&^
echo 'VERIFIED'

set /p DUMMY=Hit ENTER to continue...
