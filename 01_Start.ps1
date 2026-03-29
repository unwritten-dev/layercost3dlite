# 01_Start.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

. "$scriptDir\02_Daten.ps1"
. "$scriptDir\03_GUI.ps1"
. "$scriptDir\04_Logik.ps1"

$form.ShowDialog() | Out-Null