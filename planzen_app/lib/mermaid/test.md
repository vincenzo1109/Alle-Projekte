```mermaid
flowchart TD
    Start --> LadeDaten
    LadeDaten --> PrüfeErfolg
    PrüfeErfolg -->|Ja| ZeigeErgebnis
    PrüfeErfolg -->|Nein| ZeigeFehler
    ZeigeErgebnis --> Ende
    ZeigeFehler --> Ende
```