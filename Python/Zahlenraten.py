import random
durchgang = 0
aktiv = True
ratezahl = random.randint(0,100)
Zahlenarray = []
class bcolors:
    OK = "\033[92m"  # GREEN
    WARNING = "\033[93m"  # YELLOW
    FAIL = "\033[91m"  # RED
    RESET = "\033[0m"  # RESET COLOR


while aktiv:
    durchgang = durchgang + 1
    print()   # für Abstand (nur Optik)
    print(durchgang)
    benutzereingabe = int (input("Bitte Zahl eingeben: "))
    Zahlenarray.append(benutzereingabe)

    if benutzereingabe == ratezahl:
        print(bcolors.OK + "Gewonnen! Du hast es in " + str(durchgang) +  " Versuchen geschafft.")
        aktiv = False
        break
    elif benutzereingabe > ratezahl:
        print(bcolors.WARNING + "deine geratene Zahl ist zu groß" + bcolors.RESET)
    else:
        print(bcolors.WARNING + "deine geratene Zahl ist zu klein" + bcolors.RESET)
        
    if (durchgang == 7):
        print(bcolors.FAIL + "Schade – verloren. Einfach nochmal probieren")
        print("Es war die Zahl " + str(ratezahl))
        aktiv = False
print("Ende des Spiels")
print("Hier sind die einzelnen Zahlen, die du geraten hast:")
for zahl in Zahlenarray:
    print(zahl)