#!/bin/bash
# ================================================================================
# T2-MYSTERY: LERN-GAME GENERATOR (LPIC-1)
# Thema: Terminator 2 / Skynet Sabotage
# ================================================================================
# DESIGN-PRINZIP: Dieses Skript baut ein verschachteltes Dateisystem auf.
# Um die Lernkurve flach to halten, wird der Spieler durch eine Kette von 
# Hinweise ("Breadcrumbs") geleitet. Hinweis 2 ist erst lesbar, wenn Raum 1 
# gelöst wurde. Das trainiert das Kombinieren von Befehlen.

# 1. ORDNERSTRUKTUR ANLEGEN
# Jedes Verzeichnis repräsentiert eine "Ermittlungs-Ebene"
mkdir -p t2_mystery/behoerden/pescadero_archiv
mkdir -p t2_mystery/lapd_and_schools
mkdir -p t2_mystery/cyberdyne_labs
cd t2_mystery

echo "[+] Generiere T2-Mystery mit dynamischem Spieldesign..."

# ================================================================================
# RAUM 1: DIE SUCHE NACH SARAH CONNOR (Fokus: grep, cut, sort, uniq)
# ================================================================================

# Start-Hinweis für den Spieler (Liegt direkt im Hauptordner)
cat << 'EOF' > start_mission.txt
================================================================================
START-HINWEIS: OPERATION SKYNET DETEKTIV
================================================================================
Der T-1000 hat das System infiltriert. Wir müssen die Connors vor ihm finden!

DEIN ERSTES ZIEL: Finde Sarah Connor.
Es gibt hunderte Frauen mit diesem Namen im Einwohneramt. Wir wissen aber:
1. Die gesuchte Sarah hat exakt EIN Kind (John) und ist alleinstehend.
2. Sie wurde in eine geschlossene Psychiatrie eingewiesen.

ANLEITUNG:
- Durchsuche 'behoerden/einwohneramt_la.txt' nach den Kriterien (Kind, Familienstand).
- Gleiche das Ergebnis mit 'behoerden/kliniken_kalifornien.txt' ab (Schnittmenge!).
- Nutze 'cut', 'sort' und 'uniq -d', um die richtige Klinik-ID zu finden.
- Gehe dann in das Archiv dieser Klinik und lies ihre Akte 'interview_logs.txt'.
================================================================================
EOF

# Erstellung der Einwohner-Datenbank (1 echte Sarah, 150 Dummies)
cat << 'EOF' > behoerden/einwohneramt_la.txt
ID NAME KINDER FAMILIENSTAND ADRESAUSWEIS
101 Sarah Connor 0 verheiratet 555-9012
102 Sarah Connor 2 alleinstehend 555-4321
103 Sarah Connor 1 alleinstehend 555-1991  # <-- DIE ECHTE SARAH
104 Sarah Connor 3 verheiratet 555-7890
105 Sarah Connor 0 alleinstehend 555-3344
EOF

# Dummy-Daten generieren, um die Nutzung von 'sort' und 'uniq' zu erzwingen
for i in {106..250}; do
    echo "$i Sarah Connor $((RANDOM%4)) alleinstehend 555-$((RANDOM%9000+1000))" >> behoerden/einwohneramt_la.txt
done

# Klinik-Liste mit IDs erzeugen
cat << 'EOF' > behoerden/kliniken_kalifornien.txt
Klinik-ID Patientin Status
ARK-404 Harleen Quinzel Einschluss
PES-103 Sarah Connor Einschluss          # <-- HIER IST SIE (Pescadero State Hospital)
NPM-902 Ellen Ripley Entlassen
EOF

for i in {1..50}; do
    echo "KLN-$((RANDOM%900+100)) Jane Doe Einschluss" >> behoerden/kliniken_kalifornien.txt
done

# PROFI-TIPP SPILDESIGN: Der "Breadcrumb" (Brotkrümel)
# Der nächste Hinweis (Strang 2) wird hier in Sarahs Akte versteckt.
# Der Spieler findet ihn NUR, wenn er die richtige Klinik knackt und die Akte öffnet.
cat << 'EOF' > behoerden/pescadero_archiv/interview_logs.txt
Dr. Silberman: Patientin zeigt Wahnvorstellungen bezüglich einer nuklearen Apokalypse.
Sarah Connor: Sie sind verdammt noch mal alle tot! Am 29. August 1997 geht die Welt unter!
Dr. Silberman: Notiz: Patientin sorgt sich um ihren Sohn John, der untergetaucht ist.

================================================================================
HINWEISBLATT 2: DER SOHN (Wird freigeschaltet, weil du Sarahs Akte gefunden hast)
================================================================================
John Connor ist untergetaucht und knackt Geldautomaten, um zu überleben.
Wir müssen herausfinden, was für ein Fluchtfahrzeug er fährt, um ihn abzufangen.

ANLEITUNG:
1. Wechsle in den Ordner 'lapd_and_schools'.
2. Nutze 'cut -d "," -f 3' auf die 'atm_hacks.csv', um die Namen der Hacker zu isolieren.
3. Suche diesen Namen in den Schulakten ('school_records.txt'), um sicherzugehen.
4. Schau mit 'grep' in der 'motorcycle_registry.db' nach, welches Fahrzeug auf 
   seinen Namen registriert ist. Das Kennzeichen ist der Code für das Cyberdyne-Labor!
================================================================================
EOF


# ================================================================================
# RAUM 2: JOHNS CYBER-SPUREN (Fokus: cut mit Delimiter, csv-Handling)
# ================================================================================

# CSV-Datei für Geldautomaten-Hacks erzeugen
cat << 'EOF' > lapd_and_schools/atm_hacks.csv
Zeit,Betrag,Name,TerminalID
10:14,$300,Tim Janik,ATM-LA-01
11:22,$500,John Connor,ATM-LA-04      # <-- HIER IST JOHNS SPUR
12:05,$100,Danny Cook,ATM-LA-02
EOF

for i in {1..100}; do
    echo "1$((RANDOM%9)):$((RANDOM%5))$((RANDOM%9)),\$$((RANDOM%800+20)),Kid-$((RANDOM%900)),ATM-LA-$((RANDOM%9))" >> lapd_and_schools/atm_hacks.csv
done

# Schulakte
cat << 'EOF' > lapd_and_schools/school_records.txt
SCHULE SCHUELER VERGEHEN STATUS
Venice-High Tim Janik Schwänzen Verwarnung
Reseda-High John Connor Automatensabotage Suspendiert
Burroughs-High Danny Cook Schlägerei Arrest
EOF

# Das Motorrad-Register (DMV)
# Das Kennzeichen (2LA911) dient als Brücke für das Cyberdyne-Rätsel
cat << 'EOF' > lapd_and_schools/motorcycle_registry.db
HALTER FAHRZEUG KENNZEICHEN STATUS
Tim Janik Scooter 3XYZ89 Aktiv
John Connor Honda-Dirtbike 2LA911 Aktiv  # <-- FAHRZEUG: Honda-Dirtbike, CODE: 2LA911
Danny Cook BMX-Bike NONE Aktiv
EOF


# ================================================================================
# RAUM 3: DIE CYBERDYNE-SABOTAGE (Fokus: LPIC-Themen: chmod, chown, ps, kill, pkill)
# ================================================================================

# Verschlüsselte Datei erzeugen
echo "Sicherheits-Log: Das Doomsday-Datum aus Sarahs Akte (Auge-in-Auge) ist der Entschärfungscode!" > cyberdyne_labs/lab_code.enc

# PROFI-TIPP SPILDESIGN: LPIC-Rechte-Rätsel
# Wir entziehen der aktuellen Datei absichtlich die Leserechte für den normalen User.
# Der Spieler muss 'chmod 644' nutzen, um die Datei überhaupt erst 'catten' zu können.
chmod 000 cyberdyne_labs/lab_code.enc

# Hinweis für das finale Rätsel platzieren
cat << 'EOF' > cyberdyne_labs/README_LAB.txt
================================================================================
HINWEISBLATT 3: CYBERDYNE-LABOR IM LOCKDOWN
================================================================================
Skynet hat einen Sabotage-Wurm gestartet! Er blockiert das System.

ANLEITUNG:
1. Die Datei 'lab_code.enc' ist gesperrt. Ändere die Dateirechte mit 'chmod', 
   damit du sie lesen kannst.
2. Finde den bösartigen Hintergrundprozess auf dem System.
   Nutze 'ps aux | grep skynet' oder 'pgrep -f skynet_worm'.
3. Töte den Prozess mit 'kill' oder 'pkill'.
4. Sobald der Prozess tot ist, kombiniere das Doomsday-Datum (aus Sarahs Akte)
   und das Fahrzeug (aus Johns Ermittlung), um den Zentralrechner to stoppen!
================================================================================
EOF

# PROFI-TIPP LERN-SCAFFOLDING: Echten Hintergrundprozess starten
# Wir starten ein echtes, harmloses Hintergrund-Skript, damit der Spieler 
# reale 'ps'- und 'kill'-Erfahrungen sammelt, genau wie in der LPIC-Prüfung.
cat << 'EOF' > /tmp/skynet_worm.sh
#!/bin/bash
# Skynet System-Sperre (Simulierter Wurm für das Lernspiel)
while true; do 
    sleep 5
done
EOF
chmod +x /tmp/skynet_worm.sh
/tmp/skynet_worm.sh &
SKYNET_PID=$!

# ABSCHLUSS-MELDUNG
echo "[+] Erfolg! Spielumgebung unter '$(pwd)' aufgebaut."
echo "========================================================"
echo "DEIN STARTPUNKT:"
echo "Gib im Terminal ein:  cat start_mission.txt"
echo "========================================================"

# ================================================================================
# ARCHITEKTUR-LOG & DESIGN-PLAYBOOK (Hintergrundwissen für die Entwicklung)
# ================================================================================
: << 'DESIGN_PLAYBOOK'

  1. WAS DIESES SPILDESIGN FÜR DICH TUT:
  ------------------------------------------------------------------------------
  * Es erzwingt logische Ketten: 
    Du kannst Johns Motorrad nicht erraten, ohne vorher Sarahs Akte gelesen zu 
    haben, da dir sonst der Hinweis auf die 'lapd_and_schools'-Dateien fehlt.
  
  * Es trainiert LPIC-Rechte: 
    Wenn du im 'cyberdyne_labs'-Ordner ankommst und 'cat lab_code.enc' tippst, 
    sagt Linux sofort 'Permission denied'. Du musst dein Wissen über 'chmod' 
    anwenden.
  
  * Es nutzt echte Prozesse: 
    Der 'skynet_worm.sh' läuft real auf deinem PC im Hintergrund. Du musst ihn 
    mit echten Linux-Befehlen aufspüren und abschießen.

  2. NÄCHSTE ENTWICKLUNGSSTUFEN (Ausblick für den Ausbau):
  ------------------------------------------------------------------------------
  * Möchtest du, dass wir für die nächste Stufe Variablen und automatische 
    Erfolgsprüfungen einbauen (z. B. ein interaktives Skript am Ende, das 
    überprüft, ob du das richtige Datum und den Code eingibst)?
  
  * Oder möchtest du weitere fundamentale LPIC-Befehle wie 'tar' (Archive packen) 
    oder 'ln' (Symlinks finden und verfolgen) als neue Rätsel hinzufügen?

DESIGN_PLAYBOOK
