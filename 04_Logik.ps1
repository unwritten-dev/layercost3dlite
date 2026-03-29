# 04_Logik.ps1

Update-ComboBox $cmbProject $global:projects
Update-ComboBox $cmbPrinter $global:printers
Update-ComboBox $cmbFilament $global:filaments
Update-ComboBox $cmbExtras $global:extras

# --- Projektverwaltung ---
function Load-ProjectIntoGUI {
    if ($cmbProject.SelectedIndex -lt 0) { return }
    $proj = $global:projects[$cmbProject.SelectedIndex]
    
    $global:addedPartsList = @($proj.Parts)
    $lstParts.Items.Clear()
    foreach ($p in $global:addedPartsList) { 
        $pName = if ($p.PrinterName) { $p.PrinterName } else { "Unbekannt" }
        $fName = if ($p.FilamentName) { $p.FilamentName } else { "Unbekannt" }
        $count = if ($p.Count) { $p.Count } else { 1 }
        $p.Count = $count
        
        $lstParts.Items.Add("${count}x $($p.Name) | $pName & $fName | $($p.Time)h | $($p.Weight)g") | Out-Null 
    }

    $global:addedExtrasList = @($proj.Extras)
    $lstExtras.Items.Clear()
    foreach ($ex in $global:addedExtrasList) { $lstExtras.Items.Add("$($ex.Count) x $($ex.Name) = $([math]::Round($ex.TotalCost, 2)) €") | Out-Null }

    $global:addedMiscList = @($proj.Misc)
    $lstMisc.Items.Clear()
    foreach ($m in $global:addedMiscList) { $lstMisc.Items.Add("$($m.Name) = $([math]::Round($m.Cost, 2)) €") | Out-Null }

    $lblStats.Text = "Dauer: 0 h | Gewicht: 0 g"
    $lblTotal.Text = "Gesamtkosten: 0.00 €"
    $global:totalCost = $null
}

$cmbProject.add_SelectedIndexChanged({ Load-ProjectIntoGUI })

$btnAddProject.Add_Click({
    $name = Show-InputDialog "Neues Projekt" "Projektname:" ""
    if ($name) {
        $newProj = @{ Name = $name; Parts = @(); Extras = @(); Misc = @() }
        $global:projects += $newProj
        Save-Projects
        $cmbProject.Items.Add($name) | Out-Null
        $cmbProject.SelectedItem = $name
    }
})

$btnEditProject.Add_Click({
    if ($cmbProject.SelectedIndex -ge 0) {
        $oldName = $cmbProject.SelectedItem
        $newName = Show-InputDialog "Projekt umbenennen" "Neuer Projektname:" $oldName
        if ($newName -and $newName -ne $oldName) {
            $global:projects[$cmbProject.SelectedIndex].Name = $newName
            Save-Projects
            
            $idx = $cmbProject.SelectedIndex
            $cmbProject.Items[$idx] = $newName
            $cmbProject.SelectedItem = $newName
            
            [System.Windows.Forms.MessageBox]::Show("Projekt erfolgreich in '$newName' umbenannt!", "Info")
        }
    }
})

$btnSaveProject.Add_Click({
    if ($cmbProject.SelectedIndex -ge 0) {
        $proj = $global:projects[$cmbProject.SelectedIndex]
        $proj.Parts = $global:addedPartsList
        $proj.Extras = $global:addedExtrasList
        $proj.Misc = $global:addedMiscList
        Save-Projects
        [System.Windows.Forms.MessageBox]::Show("Projekt '$($proj.Name)' erfolgreich gespeichert!", "Info")
    }
})

$btnDelProject.Add_Click({
    if ($global:projects.Count -le 1) { [System.Windows.Forms.MessageBox]::Show("Das letzte Projekt kann nicht gelöscht werden.", "Info"); return }
    $res = [System.Windows.Forms.MessageBox]::Show("Möchtest du das Projekt wirklich löschen?", "Bestätigung", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
        $idx = $cmbProject.SelectedIndex
        $global:projects = @($global:projects | Where-Object { $_.Name -ne $cmbProject.SelectedItem })
        Save-Projects
        $cmbProject.Items.RemoveAt($idx)
        $cmbProject.SelectedIndex = 0
    }
})


# --- Profilverwaltung (Hinzufügen, Bearbeiten, Löschen) ---
$btnAddPrinter.Add_Click({
    $new = Show-ItemDialog "Neuen Drucker" "Name:" "Kosten pro Stunde (€):" "" ""
    if ($new) { $global:printers += $new; Save-Printers; Update-ComboBox $cmbPrinter $global:printers; $cmbPrinter.SelectedItem = $new.Name }
})
$btnEditPrinter.Add_Click({
    if ($cmbPrinter.SelectedIndex -ge 0) {
        $item = $global:printers[$cmbPrinter.SelectedIndex]
        $edit = Show-ItemDialog "Drucker bearbeiten" "Name:" "Kosten pro Stunde (€):" $item.Name $item.Cost
        if ($edit) { $item.Name = $edit.Name; $item.Cost = $edit.Cost; Save-Printers; Update-ComboBox $cmbPrinter $global:printers; $cmbPrinter.SelectedItem = $edit.Name }
    }
})
$btnDelPrinter.Add_Click({
    if ($cmbPrinter.SelectedIndex -ge 0) {
        if ($global:printers.Count -le 1) { [System.Windows.Forms.MessageBox]::Show("Der letzte Drucker kann nicht gelöscht werden.", "Info"); return }
        $res = [System.Windows.Forms.MessageBox]::Show("Drucker '$($cmbPrinter.SelectedItem)' löschen?", "Löschen", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
            $global:printers = @($global:printers | Where-Object { $_.Name -ne $cmbPrinter.SelectedItem })
            Save-Printers; Update-ComboBox $cmbPrinter $global:printers
        }
    }
})

$btnAddFilament.Add_Click({
    $new = Show-ItemDialog "Neues Filament" "Name:" "Preis pro kg (€):" "" ""
    if ($new) { $global:filaments += $new; Save-Filaments; Update-ComboBox $cmbFilament $global:filaments; $cmbFilament.SelectedItem = $new.Name }
})
$btnEditFilament.Add_Click({
    if ($cmbFilament.SelectedIndex -ge 0) {
        $item = $global:filaments[$cmbFilament.SelectedIndex]
        $edit = Show-ItemDialog "Filament bearbeiten" "Name:" "Preis pro kg (€):" $item.Name $item.Cost
        if ($edit) { $item.Name = $edit.Name; $item.Cost = $edit.Cost; Save-Filaments; Update-ComboBox $cmbFilament $global:filaments; $cmbFilament.SelectedItem = $edit.Name }
    }
})
$btnDelFilament.Add_Click({
    if ($cmbFilament.SelectedIndex -ge 0) {
        if ($global:filaments.Count -le 1) { [System.Windows.Forms.MessageBox]::Show("Das letzte Filament kann nicht gelöscht werden.", "Info"); return }
        $res = [System.Windows.Forms.MessageBox]::Show("Filament '$($cmbFilament.SelectedItem)' löschen?", "Löschen", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
            $global:filaments = @($global:filaments | Where-Object { $_.Name -ne $cmbFilament.SelectedItem })
            Save-Filaments; Update-ComboBox $cmbFilament $global:filaments
        }
    }
})

$btnAddExtraProfile.Add_Click({
    $new = Show-ItemDialog "Neues Zubehör" "Name:" "Preis pro Stück (€):" "" ""
    if ($new) { $global:extras += $new; Save-Extras; Update-ComboBox $cmbExtras $global:extras; $cmbExtras.SelectedItem = $new.Name }
})
$btnEditExtraProfile.Add_Click({
    if ($cmbExtras.SelectedIndex -ge 0) {
        $item = $global:extras[$cmbExtras.SelectedIndex]
        $edit = Show-ItemDialog "Zubehör bearbeiten" "Name:" "Preis pro Stück (€):" $item.Name $item.Cost
        if ($edit) { $item.Name = $edit.Name; $item.Cost = $edit.Cost; Save-Extras; Update-ComboBox $cmbExtras $global:extras; $cmbExtras.SelectedItem = $edit.Name }
    }
})
$btnDelExtraProfile.Add_Click({
    if ($cmbExtras.SelectedIndex -ge 0) {
        if ($global:extras.Count -le 1) { [System.Windows.Forms.MessageBox]::Show("Das letzte Zubehör kann nicht gelöscht werden.", "Info"); return }
        $res = [System.Windows.Forms.MessageBox]::Show("Zubehör '$($cmbExtras.SelectedItem)' löschen?", "Löschen", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
            $global:extras = @($global:extras | Where-Object { $_.Name -ne $cmbExtras.SelectedItem })
            Save-Extras; Update-ComboBox $cmbExtras $global:extras
        }
    }
})


# --- Listen (Hinzufügen & gezielt Löschen) ---
$btnAddPart.Add_Click({
    try {
        if ([string]::IsNullOrWhiteSpace($txtPartName.Text)) { throw }
        $t = [double]($txtPartTime.Text -replace ',', '.')
        $w = [double]($txtPartWeight.Text -replace ',', '.')
        $c = [int]($txtPartCount.Text)
        if ($c -lt 1) { $c = 1 }
        
        $selPrinter = $global:printers[$cmbPrinter.SelectedIndex]
        $selFilament = $global:filaments[$cmbFilament.SelectedIndex]
        
        $partCost = (($t * $selPrinter.Cost) + (($w / 1000) * $selFilament.Cost)) * $c
        
        $obj = @{ 
            Name = $txtPartName.Text; 
            Time = $t; 
            Weight = $w;
            Count = $c;
            PrinterName = $selPrinter.Name;
            FilamentName = $selFilament.Name;
            Cost = $partCost
        }
        $global:addedPartsList += $obj
        $lstParts.Items.Add("${c}x $($obj.Name) | $($obj.PrinterName) & $($obj.FilamentName) | $($obj.Time)h | $($obj.Weight)g") | Out-Null
        
        $txtPartName.Text = ""; $txtPartTime.Text = ""; $txtPartWeight.Text = ""; $txtPartCount.Text = "1"
    } catch { [System.Windows.Forms.MessageBox]::Show("Bitte Name, Zeit, Gewicht und Anzahl korrekt eingeben.", "Fehler") }
})

$btnDelPart.Add_Click({
    $idx = $lstParts.SelectedIndex
    if ($idx -ge 0) {
        $temp = @()
        for ($i=0; $i -lt $global:addedPartsList.Count; $i++) { if ($i -ne $idx) { $temp += $global:addedPartsList[$i] } }
        $global:addedPartsList = $temp
        $lstParts.Items.RemoveAt($idx)
    }
})

$btnAddExtra.Add_Click({
    try {
        $count = [int]($txtExtraCount.Text)
        $selectedExtra = $global:extras[$cmbExtras.SelectedIndex]
        $totalExtraCost = $count * $selectedExtra.Cost
        
        $obj = @{ Name = $selectedExtra.Name; Count = $count; UnitCost = $selectedExtra.Cost; TotalCost = $totalExtraCost }
        $global:addedExtrasList += $obj
        $lstExtras.Items.Add("$count x $($selectedExtra.Name) = $([math]::Round($totalExtraCost, 2)) €") | Out-Null
    } catch { [System.Windows.Forms.MessageBox]::Show("Bitte gültige Menge eingeben.", "Fehler") }
})

$btnDelExtraList.Add_Click({
    $idx = $lstExtras.SelectedIndex
    if ($idx -ge 0) {
        $temp = @()
        for ($i=0; $i -lt $global:addedExtrasList.Count; $i++) { if ($i -ne $idx) { $temp += $global:addedExtrasList[$i] } }
        $global:addedExtrasList = $temp
        $lstExtras.Items.RemoveAt($idx)
    }
})

$btnAddMisc.Add_Click({
    try {
        if ([string]::IsNullOrWhiteSpace($txtMiscName.Text)) { throw }
        $c = [double]($txtMiscCost.Text -replace ',', '.')
        
        $obj = @{ Name = $txtMiscName.Text; Cost = $c }
        $global:addedMiscList += $obj
        $lstMisc.Items.Add("$($obj.Name) = $([math]::Round($obj.Cost, 2)) €") | Out-Null
        
        $txtMiscName.Text = ""; $txtMiscCost.Text = ""
    } catch { [System.Windows.Forms.MessageBox]::Show("Bitte Beschreibung und gültige Kosten eingeben.", "Fehler") }
})

$btnDelMisc.Add_Click({
    $idx = $lstMisc.SelectedIndex
    if ($idx -ge 0) {
        $temp = @()
        for ($i=0; $i -lt $global:addedMiscList.Count; $i++) { if ($i -ne $idx) { $temp += $global:addedMiscList[$i] } }
        $global:addedMiscList = $temp
        $lstMisc.Items.RemoveAt($idx)
    }
})

$btnClearLists.Add_Click({
    $global:addedPartsList = @(); $lstParts.Items.Clear()
    $global:addedExtrasList = @(); $lstExtras.Items.Clear()
    $global:addedMiscList = @(); $lstMisc.Items.Clear()
})


# --- Berechnung ---
$btnCalc.Add_Click({
    $global:totalTime = 0; $global:totalWeight = 0; $global:costParts = 0
    foreach ($p in $global:addedPartsList) { 
        $count = if ($p.Count) { $p.Count } else { 1 }
        $global:totalTime += ($p.Time * $count); 
        $global:totalWeight += ($p.Weight * $count)
        $global:costParts += $p.Cost 
    }
    
    $global:costExtras = 0
    foreach ($ex in $global:addedExtrasList) { $global:costExtras += $ex.TotalCost }

    $global:costMisc = 0
    foreach ($m in $global:addedMiscList) { $global:costMisc += $m.Cost }

    $global:totalCost = $global:costParts + $global:costExtras + $global:costMisc
    
    $lblStats.Text = "Gesamtdauer: $($global:totalTime) h | Gesamtgewicht: $($global:totalWeight) g"
    $lblTotal.Text = "Gesamtkosten: $([math]::Round($global:totalCost, 2)) €"
})


# --- NEUES PDF DESIGN LOGIK (VORON THEME) ---
$btnPdf.Add_Click({
    $btnCalc.PerformClick()

    if ($global:totalCost -eq 0 -and $global:addedPartsList.Count -eq 0 -and $global:addedExtrasList.Count -eq 0 -and $global:addedMiscList.Count -eq 0) { 
        [System.Windows.Forms.MessageBox]::Show("Das Projekt ist leer. Es gibt nichts zum Exportieren.", "Info"); return 
    }

    $projectName = $cmbProject.SelectedItem
    $dateStr = Get-Date -Format 'dd.MM.yyyy HH:mm'

    # Logo einlesen (Base64)
    $logoHtml = ""
    $logoPathPng = "$PSScriptRoot\data\logo.png"
    $logoPathJpg = "$PSScriptRoot\data\logo.jpg"
    
    # NEU: Max-Height auf 250px gesetzt und CSS für Integration optimiert
    if (Test-Path $logoPathPng) {
        $base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($logoPathPng))
        $logoHtml = "<img src='data:image/png;base64,$base64' style='max-height: 250px; max-width: 250px; object-fit: contain; float: right; border-radius: 4px;'>"
    } elseif (Test-Path $logoPathJpg) {
        $base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($logoPathJpg))
        $logoHtml = "<img src='data:image/jpeg;base64,$base64' style='max-height: 250px; max-width: 250px; object-fit: contain; float: right; border-radius: 4px;'>"
    }

    # Status Badge
    $statusText = if ($chkFinal.Checked) { "Finale Berechnung" } else { "Zwischenkalkulation" }
    $badgeClass = if ($chkFinal.Checked) { "badge-final" } else { "badge-draft" }

    # 1. HTML für Druckteile
    $partsHtml = ""
    $i = 0
    foreach ($p in $global:addedPartsList) { 
        $pName = if ($p.PrinterName) { $p.PrinterName } else { "Unbekannt" }
        $fName = if ($p.FilamentName) { $p.FilamentName } else { "Unbekannt" }
        $count = if ($p.Count) { $p.Count } else { 1 }
        
        $singleCost = $p.Cost / $count
        
        $rowClass = if ($i % 2 -ne 0) { "row-alt" } else { "" }
        $partsHtml += "<tr class='$rowClass'>
            <td><b>$($p.Name)</b></td>
            <td><span class='dimmed'>$pName<br>$fName</span></td>
            <td style='text-align:center;'><b>${count}x</b></td>
            <td>$($p.Time) h<br>$($p.Weight) g<br><span class='unit-price'>à $([math]::Round($singleCost, 2)) €</span></td>
            <td class='money'><b>$([math]::Round($p.Cost, 2)) €</b></td>
        </tr>" 
        $i++
    }
    if ($partsHtml -eq "") { $partsHtml = "<tr><td colspan='5' class='dimmed'><i>Keine Druckteile in diesem Projekt</i></td></tr>" }

    # 2. HTML für Zubehör
    $extrasHtml = ""
    $i = 0
    foreach ($ex in $global:addedExtrasList) { 
        $rowClass = if ($i % 2 -ne 0) { "row-alt" } else { "" }
        $extrasHtml += "<tr class='$rowClass'>
            <td>$($ex.Name)</td>
            <td style='text-align:center;'><b>$($ex.Count)x</b></td>
            <td class='dimmed'>à $([math]::Round($ex.UnitCost, 2)) €</td>
            <td class='money'><b>$([math]::Round($ex.TotalCost, 2)) €</b></td>
        </tr>" 
        $i++
    }
    if ($extrasHtml -eq "") { $extrasHtml = "<tr><td colspan='4' class='dimmed'><i>Kein Zubehör in diesem Projekt</i></td></tr>" }

    # 3. HTML für Misc
    $miscHtml = ""
    $i = 0
    foreach ($m in $global:addedMiscList) { 
        $rowClass = if ($i % 2 -ne 0) { "row-alt" } else { "" }
        $miscHtml += "<tr class='$rowClass'>
            <td>$($m.Name)</td>
            <td colspan='2' class='dimmed'>-</td>
            <td class='money'><b>$([math]::Round($m.Cost, 2)) €</b></td>
        </tr>" 
        $i++
    }
    if ($miscHtml -eq "") { $miscHtml = "<tr><td colspan='4' class='dimmed'><i>Keine sonstigen Kosten in diesem Projekt</i></td></tr>" }


    $htmlContent = @"
    <html>
    <head>
        <style>
            /* Entfernt Datum/Zeit und Dateipfad von Edge und entfernt den Seitenrand komplett */
            @page { margin: 0mm !important; } 
            
            /* VORON COLOR SCHEME */
            :root {
                --voron-red: #E0272D;
                --voron-dark: #222222;
                --voron-gray: #444444;
                --voron-light: #F7F7F7;
                --border-color: #DDDDDD;
            }
            
            /* Der Abstand wird jetzt über das body margin geregelt, damit Edge glücklich ist. 
               Der obere Rand wurde auf 0mm gesetzt, um oben Platz zu sparen. */
            body { font-family: 'Segoe UI', Arial, sans-serif; color: #222; margin: 0mm 20mm 20mm 20mm; padding: 0; }
            
            /* NEU: Flexbox-Ausrichtung geändert, damit das Logo und der Text oben bündig sind */
            .header-container { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 4px solid var(--voron-red); padding-bottom: 15px; margin-bottom: 30px; }
            
            /* NEU: Abstand für den Text nach oben, wenn der Body-Rand 0 ist */
            .header-text { margin-top: 25px; }
            
            .header-text h1 { margin: 0; color: var(--voron-dark); font-size: 28px; display: flex; align-items: center; text-transform: uppercase; font-weight: 800; }
            .header-text p { margin: 5px 0 0 0; color: var(--voron-gray); font-size: 14px; }
            
            .badge { display: inline-block; padding: 4px 10px; border-radius: 4px; font-size: 14px; font-weight: bold; margin-left: 15px; text-transform: uppercase; letter-spacing: 0.5px; }
            .badge-final { background-color: var(--voron-red); color: white; }
            .badge-draft { background-color: var(--voron-dark); color: white; }
            
            h3 { color: var(--voron-red); border-bottom: 2px solid var(--voron-dark); padding-bottom: 5px; margin-top: 40px; margin-bottom: 15px; font-size: 18px; text-transform: uppercase; font-weight: 700; }
            
            table { width: 100%; border-collapse: collapse; margin-bottom: 10px; font-size: 14px; }
            th { background-color: var(--voron-dark); text-align: left; padding: 10px 12px; color: white; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
            td { padding: 10px 12px; border-bottom: 1px solid var(--border-color); vertical-align: top; }
            
            .row-alt { background-color: var(--voron-light); }
            .dimmed { color: var(--voron-gray); font-size: 13px; }
            .money { text-align: right; }
            .unit-price { color: var(--voron-red); font-weight: bold; font-size: 12px; }
            
            .subtotal { background-color: #EFEFEF; font-weight: bold; }
            .subtotal td { border-top: 2px solid var(--voron-dark); border-bottom: none; }
            
            .total-box { margin-top: 50px; background-color: var(--voron-light); border: 3px solid var(--voron-red); border-radius: 4px; padding: 20px 25px; display: flex; justify-content: space-between; align-items: center; }
            .total-box span { font-size: 16px; color: var(--voron-dark); font-weight: bold; text-transform: uppercase; }
            .total-box h2 { margin: 0; color: var(--voron-red); font-size: 28px; text-align: right; }
            
            .footer { margin-top: 50px; text-align: center; color: var(--voron-gray); font-size: 12px; text-transform: uppercase; letter-spacing: 1px;}
        </style>
    </head>
    <body>
        <div class="header-container">
            <div class="header-text">
                <h1>Projekt: $projectName <span class="badge $badgeClass">$statusText</span></h1>
                <p>Kostenkalkulation | Erstellt am: $dateStr</p>
            </div>
            <div>
                $logoHtml
            </div>
        </div>

        <h3>1. 3D-Druckteile</h3>
        <table>
            <tr>
                <th width="32%">Bauteil</th>
                <th width="30%">Drucker & Material</th>
                <th width="8%" style="text-align:center;">Menge</th>
                <th width="15%">Werte (pro Stk)</th>
                <th width="15%" class="money">Gesamt</th>
            </tr>
            $partsHtml
            <tr class="subtotal">
                <td colspan="4" style="text-align: right;">Zwischensumme Druckteile:</td>
                <td class="money">$([math]::Round($global:costParts, 2)) €</td>
            </tr>
        </table>

        <h3>2. Zubehör & Hardware</h3>
        <table>
            <tr>
                <th width="45%">Artikel</th>
                <th width="15%" style="text-align:center;">Menge</th>
                <th width="25%">Einzelpreis</th>
                <th width="15%" class="money">Gesamt</th>
            </tr>
            $extrasHtml
            <tr class="subtotal">
                <td colspan="3" style="text-align: right;">Zwischensumme Zubehör:</td>
                <td class="money">$([math]::Round($global:costExtras, 2)) €</td>
            </tr>
        </table>

        <h3>3. Sonstige Kosten</h3>
        <table>
            <tr>
                <th width="50%">Beschreibung</th>
                <th width="35%" colspan="2"></th>
                <th width="15%" class="money">Gesamt</th>
            </tr>
            $miscHtml
            <tr class="subtotal">
                <td colspan="3" style="text-align: right;">Zwischensumme Sonstiges:</td>
                <td class="money">$([math]::Round($global:costMisc, 2)) €</td>
            </tr>
        </table>

        <table style="width: 100%; margin-top: 40px;">
            <tr>
                <td style="border: none; padding: 0;"></td>
                <td style="width: 350px; border: none; padding: 0;">
                    <div class="total-box">
                        <span>Gesamtsumme:</span>
                        <h2>$([math]::Round($global:totalCost, 2)) €</h2>
                    </div>
                </td>
            </tr>
        </table>
        
        <div class="footer">
            Generiert mit dem 3D-Druck Projekt Kalkulator PRO
        </div>
    </body>
    </html>
"@

    $tempHtml = "$env:TEMP\kalkulation.html"
    
    $cleanProjName = $projectName -replace '[\\/:\*\?"<>\|]', '_'
    $pdfDir = "$PSScriptRoot\pdf\$cleanProjName"
    
    if (-not (Test-Path $pdfDir)) { New-Item -ItemType Directory -Path $pdfDir -Force | Out-Null }
    
    $pdfPath = "$pdfDir\$cleanProjName`_$((Get-Date).ToString('yyyyMMdd_HHmmss')).pdf"
    
    $htmlContent | Out-File -FilePath $tempHtml -Encoding utf8

    try {
        Start-Process -FilePath "msedge" -ArgumentList "--headless", "--no-pdf-header-footer", "--print-to-pdf=`"$pdfPath`"", "`"$tempHtml`"" -Wait -WindowStyle Hidden
        [System.Windows.Forms.MessageBox]::Show("PDF erfolgreich unter 'pdf\$cleanProjName\' gespeichert!", "Erfolg")
    } catch { [System.Windows.Forms.MessageBox]::Show("Fehler beim Erstellen der PDF.", "Fehler") }
})

# Start
Load-ProjectIntoGUI