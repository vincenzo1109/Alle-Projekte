<!DOCTYPE html>
<html lang="de">
<head>
    <script rel="text/javascript" src="logic.js"></script>
    <link rel="icon" href="favicon.ico" type="image/png"/>
    <link rel="stylesheet" href="style.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TicTacToe</title>
    <?php
    $name = 'Vincent';

    ?>
</head>
<body>
<div class="grid-container">
    <header>
        <div id="logo-div">
            <img src="Logo.png" alt="Logo" class="Logo-png"/>
        </div>
        <div id="header-div">
            <h1 class="Überschrift">TicTacToe</h1>
            <h2>Dies ist eine Website, um TicTacToe zu spielen</h2>
        </div>
    </header>


    <section id="game">
        <div><h1 class="Überschrift">TicTacToe-Spiel</h1></div>
        <div id="playerdiv">
            <div id="input">
                <label for="player1">Spieler 1:</label><input type="text" placeholder="First Player name" id="player1">
                <label for="player2">Spieler 2:</label><input type="text" placeholder="Second Player name" id="player2">
            </div>
            <button onclick="FirstStart()" id="button">Erster Start (Namen speichern)
            </button>
        </div>
        <Label id="Points">Punktestand: 0 : 0 </Label>
        <label id="Currentplayer"></Label>
        <Label id="Won"> </Label>
        <div id="board">
            <div id="0" class="cell" onclick="Zeichnen(0)"></div>
            <div id="1" class="cell" onclick="Zeichnen(1)"></div>
            <div id="2" class="cell" onclick="Zeichnen(2)"></div>
            <div id="3" class="cell" onclick="Zeichnen(3)"></div>
            <div id="4" class="cell" onclick="Zeichnen(4)"></div>
            <div id="5" class="cell" onclick="Zeichnen(5)"></div>
            <div id="6" class="cell" onclick="Zeichnen(6)"></div>
            <div id="7" class="cell" onclick="Zeichnen(7)"></div>
            <div id="8" class="cell" onclick="Zeichnen(8)"></div>
        </div>
        <button onclick="Pointsreset()">Zurücksetzen der Punkte</button>
        <button onclick="Reset()">Zurücksetzen des Spielfeldes</button>
        <div id="Fehler"></div>
    </section>

    <section class="php">
        <p>
            Dein Name ist: <?= $name; ?>
        </p>
    </section>

    <footer>
        <div class="Impressum"><strong>Impressum</strong>
            Vincent Bienert
            Heinrich-Beck-Str. 23
            09112 Chemnitz
        </div>
        <div class="divider"></div>
        <div id="div-Website">
            <label for="Websites">Andere selbst programmierten Seiten: </label>
            <select id="Websites" onchange="window.location.href=this.value;">
                <option id="start" value="" selected>Projekt auswählen</option>
                <option value="">-----------</option>
                <option value="https://explicit-songs2.netlify.app/">Meine erste Website</option>
                <option value="https://vincent-bienert.netlify.app/">Lebenslauf</option>
                <option value="Rechner.html">
                    Taschenrechner
                </option>
            </select>
        </div>
        <div class="divider"></div>
        <div class="Impressum">
            <strong>Kontakt</strong>
            Email: bienert.website@gmail.com
            Telefon-Nummer: 01786091472
            Instagram: @vincenzo_2048
        </div>
    </footer>
</div>
</body>
</html>


