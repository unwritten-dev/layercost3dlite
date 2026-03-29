# LayerCost3D Lite 🖨️💸

**LayerCost3D Lite** ist ein leichtgewichtiger, portabler 3D-Druck-Kostenrechner für Windows, geschrieben in PowerShell. Er ermöglicht es Makern, die exakten Druck- und Materialkosten für komplexe Projekte zu berechnen und professionelle Rechnungen/Kalkulationen als PDF zu exportieren.

Da das Skript rein auf PowerShell und Windows Forms basiert, erfordert es **keine Installation** und **keine Datenbank-Einrichtung**.

---

## ✨ Features

* **📦 Projektverwaltung:** Erstelle, bearbeite, speichere und wechsle nahtlos zwischen verschiedenen Projekten.
* **🖨️ Profil-Management:** Lege dauerhafte Profile für deine 3D-Drucker (Kosten/Stunde), Filamente (Kosten/kg) und Hardware/Zubehör (Kosten/Stück) an.
* **🧩 Detaillierte Bauteil-Berechnung:** Jedes Druckteil innerhalb eines Projekts kann einen *eigenen* Drucker und ein *eigenes* Filament zugewiesen bekommen. Die Berechnung erfolgt automatisch anhand von Druckzeit, Gewicht und Stückzahl.
* **🔩 Zubehör & Sonstiges:** Füge Schrauben, Kugellager oder auch Pauschalkosten (wie Strom, Versand oder CAD-Designzeit) zu deiner Kalkulation hinzu.
* **📄 Professioneller PDF-Export (Voron-Theme):** Generiert auf Knopfdruck eine saubere, ansprechende PDF-Rechnung im technischen Voron-Design (Rot/Schwarz). Der Export läuft komplett unsichtbar über Microsoft Edge (Headless).
* **🏷️ Custom Logo:** Eigene Logos (`logo.png` oder `logo.jpg`) werden automatisch in die PDF integriert.
* **🧳 100% Portabel:** Alle Daten (Profile, Projekte, Logos) werden in einem lokalen `data`-Ordner direkt neben dem Programm gespeichert. Keine versteckten AppData-Einträge.

---

## 🚀 Installation & Start

### Systemvoraussetzungen
* Windows 10 oder 11
* Windows PowerShell 5.1 (standardmäßig in Windows enthalten)
* Microsoft Edge (wird für die unsichtbare PDF-Generierung benötigt)

### Loslegen
1. Lade dir dieses Repository herunter oder klone es: `git clone https://github.com/unwritten-dev/layercost3dlite.git`
2. *(Optional)* Lege dein eigenes Logo als `logo.png` oder `logo.jpg` in den Ordner `data/`.
3. **Starte das Programm durch einen Doppelklick auf die Datei `Start.vbs`.** *(Die .vbs-Datei startet das PowerShell-Skript komplett unsichtbar im Hintergrund, sodass kein störendes Konsolen-Fenster offen bleibt.)*

---

## 📁 Ordnerstruktur

Nach dem ersten Start generiert das Programm automatisch seine eigene Ordnerstruktur:

```text
LayerCost3D-Lite/
├── data/                       # Hier werden alle Daten gespeichert (Portabel)
│   ├── filaments.json          # Gespeicherte Filament-Profile
│   ├── parts.json              # Gespeichertes Hardware-Zubehör
│   ├── printer_profiles.json   # Gespeicherte Drucker-Profile
│   ├── projects.json           # Deine gespeicherten Projekte
│   └── logo.png                # (Optional) Dein Logo für die PDF
├── pdf/                        # Hier landen die exportierten PDFs (nach Projekt sortiert)
├── 01_Start.ps1                # Haupt-Loader
├── 02_Daten.ps1                # Daten- und Dateimanagement
├── 03_GUI.ps1                  # Benutzeroberfläche (Windows Forms)
├── 04_Logik.ps1                # Berechnungslogik & PDF-Export
└── Start.vbs                   # Launcher (versteckt das Konsolenfenster)