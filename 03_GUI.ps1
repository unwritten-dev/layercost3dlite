# 03_GUI.ps1

$form = New-Object System.Windows.Forms.Form
$form.Text = "3D-Druck Projekt Kalkulator PRO"
$form.Size = New-Object System.Drawing.Size(520, 920)
$form.StartPosition = "CenterScreen"

function Add-Label($text, $x, $y) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $text; $label.Location = New-Object System.Drawing.Point($x, $y); $label.AutoSize = $true
    $form.Controls.Add($label)
}

# --- 0. Projektverwaltung ---
Add-Label "Aktuelles Projekt:" 20 15
$cmbProject = New-Object System.Windows.Forms.ComboBox
$cmbProject.Location = New-Object System.Drawing.Point(20, 35); $cmbProject.Width = 175; $cmbProject.DropDownStyle = "DropDownList"
$form.Controls.Add($cmbProject)

$btnEditProject = New-Object System.Windows.Forms.Button
$btnEditProject.Text = "✎"; $btnEditProject.Location = New-Object System.Drawing.Point(200, 34); $btnEditProject.Width = 30
$form.Controls.Add($btnEditProject)

$btnAddProject = New-Object System.Windows.Forms.Button
$btnAddProject.Text = "Neu"; $btnAddProject.Location = New-Object System.Drawing.Point(235, 34); $btnAddProject.Width = 45
$form.Controls.Add($btnAddProject)

$btnSaveProject = New-Object System.Windows.Forms.Button
$btnSaveProject.Text = "Speichern"; $btnSaveProject.Location = New-Object System.Drawing.Point(285, 34); $btnSaveProject.Width = 75
$form.Controls.Add($btnSaveProject)

$btnDelProject = New-Object System.Windows.Forms.Button
$btnDelProject.Text = "Löschen"; $btnDelProject.Location = New-Object System.Drawing.Point(365, 34); $btnDelProject.Width = 75
$form.Controls.Add($btnDelProject)

$separator = New-Object System.Windows.Forms.Label
$separator.AutoSize = $false; $separator.Height = 2; $separator.Width = 460; $separator.Location = New-Object System.Drawing.Point(20, 75)
$separator.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$form.Controls.Add($separator)

# --- 1. Basis-Einstellungen ---
Add-Label "1. Drucker & Material für das nächste Bauteil wählen:" 20 90

$cmbPrinter = New-Object System.Windows.Forms.ComboBox
$cmbPrinter.Location = New-Object System.Drawing.Point(20, 115); $cmbPrinter.Width = 160; $cmbPrinter.DropDownStyle = "DropDownList"
$form.Controls.Add($cmbPrinter)

$btnAddPrinter = New-Object System.Windows.Forms.Button
$btnAddPrinter.Text = "+"; $btnAddPrinter.Location = New-Object System.Drawing.Point(185, 114); $btnAddPrinter.Width = 30
$form.Controls.Add($btnAddPrinter)

$btnEditPrinter = New-Object System.Windows.Forms.Button
$btnEditPrinter.Text = "✎"; $btnEditPrinter.Location = New-Object System.Drawing.Point(220, 114); $btnEditPrinter.Width = 30
$form.Controls.Add($btnEditPrinter)

$btnDelPrinter = New-Object System.Windows.Forms.Button
$btnDelPrinter.Text = "X"; $btnDelPrinter.Location = New-Object System.Drawing.Point(255, 114); $btnDelPrinter.Width = 30
$form.Controls.Add($btnDelPrinter)

$cmbFilament = New-Object System.Windows.Forms.ComboBox
$cmbFilament.Location = New-Object System.Drawing.Point(20, 150); $cmbFilament.Width = 160; $cmbFilament.DropDownStyle = "DropDownList"
$form.Controls.Add($cmbFilament)

$btnAddFilament = New-Object System.Windows.Forms.Button
$btnAddFilament.Text = "+"; $btnAddFilament.Location = New-Object System.Drawing.Point(185, 149); $btnAddFilament.Width = 30
$form.Controls.Add($btnAddFilament)

$btnEditFilament = New-Object System.Windows.Forms.Button
$btnEditFilament.Text = "✎"; $btnEditFilament.Location = New-Object System.Drawing.Point(220, 149); $btnEditFilament.Width = 30
$form.Controls.Add($btnEditFilament)

$btnDelFilament = New-Object System.Windows.Forms.Button
$btnDelFilament.Text = "X"; $btnDelFilament.Location = New-Object System.Drawing.Point(255, 149); $btnFilament.Width = 30
$form.Controls.Add($btnDelFilament)


# --- 2. Druckdateien ---
Add-Label "2. Druckdatei (Bauteil) hinzufügen:" 20 200
Add-Label "Dateiname:" 20 225
$txtPartName = New-Object System.Windows.Forms.TextBox
$txtPartName.Location = New-Object System.Drawing.Point(20, 245); $txtPartName.Width = 130
$form.Controls.Add($txtPartName)

Add-Label "Zeit(h):" 160 225
$txtPartTime = New-Object System.Windows.Forms.TextBox
$txtPartTime.Location = New-Object System.Drawing.Point(160, 245); $txtPartTime.Width = 40
$form.Controls.Add($txtPartTime)

Add-Label "Gew.(g):" 210 225
$txtPartWeight = New-Object System.Windows.Forms.TextBox
$txtPartWeight.Location = New-Object System.Drawing.Point(210, 245); $txtPartWeight.Width = 40
$form.Controls.Add($txtPartWeight)

Add-Label "Anzahl:" 260 225
$txtPartCount = New-Object System.Windows.Forms.TextBox
$txtPartCount.Location = New-Object System.Drawing.Point(260, 245); $txtPartCount.Width = 40; $txtPartCount.Text = "1"
$form.Controls.Add($txtPartCount)

$btnAddPart = New-Object System.Windows.Forms.Button
$btnAddPart.Text = "Hinzufügen"; $btnAddPart.Location = New-Object System.Drawing.Point(310, 243); $btnAddPart.Width = 100
$form.Controls.Add($btnAddPart)

$lstParts = New-Object System.Windows.Forms.ListBox
$lstParts.Location = New-Object System.Drawing.Point(20, 275); $lstParts.Size = New-Object System.Drawing.Size(390, 80)
$form.Controls.Add($lstParts)

$btnDelPart = New-Object System.Windows.Forms.Button
$btnDelPart.Text = "X"; $btnDelPart.Location = New-Object System.Drawing.Point(420, 275); $btnDelPart.Size = New-Object System.Drawing.Size(30, 80)
$form.Controls.Add($btnDelPart)


# --- 3. Zubehör ---
Add-Label "3. Zubehör / Hardware hinzufügen:" 20 370
$cmbExtras = New-Object System.Windows.Forms.ComboBox
$cmbExtras.Location = New-Object System.Drawing.Point(20, 395); $cmbExtras.Width = 130; $cmbExtras.DropDownStyle = "DropDownList"
$form.Controls.Add($cmbExtras)

$btnAddExtraProfile = New-Object System.Windows.Forms.Button
$btnAddExtraProfile.Text = "+"; $btnAddExtraProfile.Location = New-Object System.Drawing.Point(155, 394); $btnAddExtraProfile.Width = 30
$form.Controls.Add($btnAddExtraProfile)

$btnEditExtraProfile = New-Object System.Windows.Forms.Button
$btnEditExtraProfile.Text = "✎"; $btnEditExtraProfile.Location = New-Object System.Drawing.Point(190, 394); $btnEditExtraProfile.Width = 30
$form.Controls.Add($btnEditExtraProfile)

$btnDelExtraProfile = New-Object System.Windows.Forms.Button
$btnDelExtraProfile.Text = "X"; $btnDelExtraProfile.Location = New-Object System.Drawing.Point(225, 394); $btnDelExtraProfile.Width = 30
$form.Controls.Add($btnDelExtraProfile)

Add-Label "Menge:" 265 375
$txtExtraCount = New-Object System.Windows.Forms.TextBox
$txtExtraCount.Location = New-Object System.Drawing.Point(265, 395); $txtExtraCount.Width = 40; $txtExtraCount.Text = "1"
$form.Controls.Add($txtExtraCount)

$btnAddExtra = New-Object System.Windows.Forms.Button
$btnAddExtra.Text = "Hinzufügen"; $btnAddExtra.Location = New-Object System.Drawing.Point(315, 393); $btnAddExtra.Width = 95
$form.Controls.Add($btnAddExtra)

$lstExtras = New-Object System.Windows.Forms.ListBox
$lstExtras.Location = New-Object System.Drawing.Point(20, 425); $lstExtras.Size = New-Object System.Drawing.Size(390, 80)
$form.Controls.Add($lstExtras)

$btnDelExtraList = New-Object System.Windows.Forms.Button
$btnDelExtraList.Text = "X"; $btnDelExtraList.Location = New-Object System.Drawing.Point(420, 425); $btnDelExtraList.Size = New-Object System.Drawing.Size(30, 80)
$form.Controls.Add($btnDelExtraList)


# --- 4. Sonstige Kosten ---
Add-Label "4. Sonstige Kosten (z.B. Versand, Designzeit) hinzufügen:" 20 520
Add-Label "Beschreibung:" 20 545
$txtMiscName = New-Object System.Windows.Forms.TextBox
$txtMiscName.Location = New-Object System.Drawing.Point(20, 565); $txtMiscName.Width = 180
$form.Controls.Add($txtMiscName)

Add-Label "Kosten (€):" 210 545
$txtMiscCost = New-Object System.Windows.Forms.TextBox
$txtMiscCost.Location = New-Object System.Drawing.Point(210, 565); $txtMiscCost.Width = 80
$form.Controls.Add($txtMiscCost)

$btnAddMisc = New-Object System.Windows.Forms.Button
$btnAddMisc.Text = "Hinzufügen"; $btnAddMisc.Location = New-Object System.Drawing.Point(300, 563); $btnAddMisc.Width = 110
$form.Controls.Add($btnAddMisc)

$lstMisc = New-Object System.Windows.Forms.ListBox
$lstMisc.Location = New-Object System.Drawing.Point(20, 595); $lstMisc.Size = New-Object System.Drawing.Size(390, 60)
$form.Controls.Add($lstMisc)

$btnDelMisc = New-Object System.Windows.Forms.Button
$btnDelMisc.Text = "X"; $btnDelMisc.Location = New-Object System.Drawing.Point(420, 595); $btnDelMisc.Size = New-Object System.Drawing.Size(30, 60)
$form.Controls.Add($btnDelMisc)


# --- 5. Ausgabe ---
$btnClearLists = New-Object System.Windows.Forms.Button
$btnClearLists.Text = "Alle Listen leeren"
$btnClearLists.Location = New-Object System.Drawing.Point(20, 670); $btnClearLists.Width = 150
$form.Controls.Add($btnClearLists)

$lblTotal = New-Object System.Windows.Forms.Label
$lblTotal.Text = "Gesamtkosten: 0.00 €"
$lblTotal.Location = New-Object System.Drawing.Point(20, 715); $lblTotal.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold); $lblTotal.AutoSize = $true
$form.Controls.Add($lblTotal)

$lblStats = New-Object System.Windows.Forms.Label
$lblStats.Text = "Dauer: 0 h | Gewicht: 0 g"
$lblStats.Location = New-Object System.Drawing.Point(20, 745); $lblStats.AutoSize = $true
$form.Controls.Add($lblStats)

$btnCalc = New-Object System.Windows.Forms.Button
$btnCalc.Text = "Kosten Berechnen"
$btnCalc.Location = New-Object System.Drawing.Point(20, 785); $btnCalc.Size = New-Object System.Drawing.Size(150, 40)
$form.Controls.Add($btnCalc)

$btnPdf = New-Object System.Windows.Forms.Button
$btnPdf.Text = "PDF Erzeugen"
$btnPdf.Location = New-Object System.Drawing.Point(180, 785); $btnPdf.Size = New-Object System.Drawing.Size(150, 40)
$form.Controls.Add($btnPdf)

$chkFinal = New-Object System.Windows.Forms.CheckBox
$chkFinal.Text = "Finale Berechnung"
$chkFinal.Location = New-Object System.Drawing.Point(340, 796)
$chkFinal.AutoSize = $true
$form.Controls.Add($chkFinal)