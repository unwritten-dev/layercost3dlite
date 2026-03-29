# 02_Daten.ps1

$global:configDir = "$PSScriptRoot\data"

$global:printersFile  = "$global:configDir\printer_profiles.json"
$global:filamentsFile = "$global:configDir\filaments.json"
$global:extrasFile    = "$global:configDir\parts.json"
$global:projectsFile  = "$global:configDir\projects.json"

if (-not (Test-Path $global:configDir)) { New-Item -ItemType Directory -Path $global:configDir | Out-Null }

# --- Profile laden ---
if (-not (Test-Path $global:printersFile)) { @( @{ Name = "Standard Drucker"; Cost = 0.50 } ) | ConvertTo-Json -Depth 3 | Out-File -FilePath $global:printersFile -Encoding utf8 }
$global:printers = Get-Content $global:printersFile -Encoding utf8 | ConvertFrom-Json
if ($global:printers.GetType().Name -ne "Object[]") { $global:printers = @($global:printers) }

if (-not (Test-Path $global:filamentsFile)) { @( @{ Name = "PLA Standard"; Cost = 20.00 } ) | ConvertTo-Json -Depth 3 | Out-File -FilePath $global:filamentsFile -Encoding utf8 }
$global:filaments = Get-Content $global:filamentsFile -Encoding utf8 | ConvertFrom-Json
if ($global:filaments.GetType().Name -ne "Object[]") { $global:filaments = @($global:filaments) }

if (-not (Test-Path $global:extrasFile)) { @( @{ Name = "M3x10 Schraube"; Cost = 0.05 } ) | ConvertTo-Json -Depth 3 | Out-File -FilePath $global:extrasFile -Encoding utf8 }
$global:extras = Get-Content $global:extrasFile -Encoding utf8 | ConvertFrom-Json
if ($global:extras.GetType().Name -ne "Object[]") { $global:extras = @($global:extras) }

# --- Projekte laden ---
if (-not (Test-Path $global:projectsFile)) {
    @( @{ Name = "Standard Projekt"; Parts = @(); Extras = @(); Misc = @() } ) | ConvertTo-Json -Depth 5 | Out-File -FilePath $global:projectsFile -Encoding utf8
}
$global:projects = Get-Content $global:projectsFile -Encoding utf8 | ConvertFrom-Json
if ($global:projects.GetType().Name -ne "Object[]") { $global:projects = @($global:projects) }

$global:addedPartsList = @()
$global:addedExtrasList = @()
$global:addedMiscList = @()

# --- Speichern-Funktionen ---
function Save-Printers { $global:printers | ConvertTo-Json -Depth 3 | Out-File -FilePath $global:printersFile -Encoding utf8 }
function Save-Filaments { $global:filaments | ConvertTo-Json -Depth 3 | Out-File -FilePath $global:filamentsFile -Encoding utf8 }
function Save-Extras { $global:extras | ConvertTo-Json -Depth 3 | Out-File -FilePath $global:extrasFile -Encoding utf8 }
function Save-Projects { $global:projects | ConvertTo-Json -Depth 5 | Out-File -FilePath $global:projectsFile -Encoding utf8 }

# --- GUI Hilfsfunktionen ---
function Update-ComboBox($cmb, $list) {
    $cmb.Items.Clear()
    if ($list) { $list | ForEach-Object { $cmb.Items.Add($_.Name) | Out-Null } }
    if ($cmb.Items.Count -gt 0) { $cmb.SelectedIndex = 0 }
}

function Show-ItemDialog($Title, $LabelName, $LabelCost, $DefaultName, $DefaultCost) {
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text = $Title; $dlg.Size = New-Object System.Drawing.Size(300, 220)
    $dlg.StartPosition = "CenterParent"; $dlg.FormBorderStyle = "FixedDialog"; $dlg.MaximizeBox = $false

    $lblName = New-Object System.Windows.Forms.Label
    $lblName.Text = $LabelName; $lblName.Location = New-Object System.Drawing.Point(20, 20); $lblName.AutoSize = $true
    $dlg.Controls.Add($lblName)

    $txtName = New-Object System.Windows.Forms.TextBox
    $txtName.Location = New-Object System.Drawing.Point(20, 40); $txtName.Width = 240
    if ($DefaultName) { $txtName.Text = $DefaultName }
    $dlg.Controls.Add($txtName)

    $lblCost = New-Object System.Windows.Forms.Label
    $lblCost.Text = $LabelCost; $lblCost.Location = New-Object System.Drawing.Point(20, 80); $lblCost.AutoSize = $true
    $dlg.Controls.Add($lblCost)

    $txtCost = New-Object System.Windows.Forms.TextBox
    $txtCost.Location = New-Object System.Drawing.Point(20, 100); $txtCost.Width = 100
    if ($DefaultCost) { $txtCost.Text = $DefaultCost }
    $dlg.Controls.Add($txtCost)

    $btnSave = New-Object System.Windows.Forms.Button
    $btnSave.Text = "Speichern"; $btnSave.Location = New-Object System.Drawing.Point(20, 140); $btnSave.Size = New-Object System.Drawing.Size(100, 30)
    $dlg.Controls.Add($btnSave)

    $btnSave.Add_Click({
        try {
            if ([string]::IsNullOrWhiteSpace($txtName.Text)) { throw "Name leer" }
            $cost = [double]($txtCost.Text -replace ',', '.')
            $dlg.DialogResult = [System.Windows.Forms.DialogResult]::OK
        } catch { [System.Windows.Forms.MessageBox]::Show("Bitte gültigen Namen und Preis eingeben.", "Fehler") }
    })

    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { return @{ Name = $txtName.Text; Cost = [double]($txtCost.Text -replace ',', '.') } }
    return $null
}

function Show-InputDialog($Title, $LabelName, $DefaultText) {
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text = $Title; $dlg.Size = New-Object System.Drawing.Size(300, 150)
    $dlg.StartPosition = "CenterParent"; $dlg.FormBorderStyle = "FixedDialog"; $dlg.MaximizeBox = $false

    $lblName = New-Object System.Windows.Forms.Label
    $lblName.Text = $LabelName; $lblName.Location = New-Object System.Drawing.Point(20, 20); $lblName.AutoSize = $true
    $dlg.Controls.Add($lblName)

    $txtName = New-Object System.Windows.Forms.TextBox
    $txtName.Location = New-Object System.Drawing.Point(20, 40); $txtName.Width = 240
    if ($DefaultText) { $txtName.Text = $DefaultText }
    $dlg.Controls.Add($txtName)

    $btnSave = New-Object System.Windows.Forms.Button
    $btnSave.Text = "OK"; $btnSave.Location = New-Object System.Drawing.Point(20, 70); $btnSave.Size = New-Object System.Drawing.Size(100, 30)
    $dlg.Controls.Add($btnSave)

    $btnSave.Add_Click({
        if ([string]::IsNullOrWhiteSpace($txtName.Text)) { [System.Windows.Forms.MessageBox]::Show("Name darf nicht leer sein.", "Fehler") }
        else { $dlg.DialogResult = [System.Windows.Forms.DialogResult]::OK }
    })

    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { return $txtName.Text }
    return $null
}