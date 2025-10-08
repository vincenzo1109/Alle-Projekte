import random
def leicht(AS):
    return random.randint(1, min(3, AS))

def mittel(AS):
    for i in range(1, 4):
        if (AS - i) % 4 == 1:
            return i
    return random.randint(1, min(3, AS))

def schwer(AS):
    if AS % 4 == 1:
        return random.randint(1, min(3, AS))
    else:
        return (AS - 1) % 4

def Streichholzspiel():
    class bcolors:
            OK = "\033[92m"  # GREEN
            WARNING = "\033[93m"  # YELLOW
            FAIL = "\033[91m"  # RED
            RESET = "\033[0m"  # RESET COLOR
                
    Art = input("2 Spieler oder KI vs Spieler (entweder mit Spieler oder KI antworten):) : ").lower
    
    if Art == "spieler": 
        print("Willkomen im Streichholzspiel")
        AS = int(input("Mit wie vielen Hölzern wollt ihr spielen?: "))
        
        while AS >= 1:
            print(bcolors.WARNING + "Spieler 1: Du bist am Zug" + bcolors.RESET)
            
            if AS > 1:
                print("Es sind noch " + str(AS) + " Streichhölzer da")
            else: print(bcolors.FAIL + "Es ist nur noch " + str(AS) + " Streichholz da" + bcolors.RESET)
            print()
            
            S1 = int(input("Wie viele möchtest du nehmen? (von 1-3): "))
            while S1 > 3 or S1 < 1 or S1 > AS:
                print(bcolors.FAIL + "EEERRRRRRRRROOOORR: Entweder zu wenig Hölzer oder nicht zwischen 1 und 3" + bcolors.RESET)
                S1 = int(input("Wie viele möchtest du nehmen? (von 1-3): "))
            
            AS -= S1
            
            if AS == 0:
                print(bcolors.FAIL + "Spieler 1 hat das letzte Streichholz genommen und verliert" + bcolors.RESET)
                print(bcolors.OK + "Spieler 2 hat somit gewonnen" + bcolors.RESET)
                break
        
        
            print(bcolors.WARNING + "Spieler 2: Du bist am Zug" + bcolors.RESET)
            print("Es sind noch " + str(AS) + " Streichhölzer da")
            print()
            
            S1 = int(input("Wie viele möchtest du nehmen? (von 1-3): "))
            
            while S1 > 3 or S1 < 1 or S1 > AS:
                print(bcolors.FAIL + "EEERRRRRRRRROOOORR: Entweder zu wenig Hölzer oder nicht zwischen 1 und 3" + bcolors.RESET)
                S1 = int(input("Wie viele möchtest du nehmen? (von 1-3): "))
            
            AS -= S1
            
            if AS == 0:
                print(bcolors.FAIL + "Spieler 2 hat das letzte Streichholz genommen und verliert" + bcolors.RESET)
                print(bcolors.OK + "Spieler 1 hat somit gewonnen" + bcolors.RESET)
                break
    else:
        print("Willkomen im Streichholzspiel")
        
        schwierigkeit = str(input("Wie schwierig soll die KI sein? (leicht, mittel, schwer): ").lower)
        AS = int(input("Mit wie vielen Hölzern wollt ihr spielen?: "))
        
        print()
        while AS >= 1:
            
            print(bcolors.WARNING + "Spieler 1: Du bist am Zug" + bcolors.RESET)
            if AS > 1:
                print("Es sind noch " + str(AS) + " Streichhölzer da")
            else: print(bcolors.FAIL + "Es ist nur noch " + str(AS) + " Streichholz da" + bcolors.RESET)
            print()
            
            S1 = int(input("Wie viele möchtest du nehmen? (von 1-3): "))
            while S1 > 3 or S1 < 1 or S1 > AS:
                print(bcolors.FAIL + "EEERRRRRRRRROOOORR: Entweder zu wenig Hölzer oder nicht zwischen 1 und 3" + bcolors.RESET)
                S1 = int(input("Wie viele möchtest du nehmen? (von 1-3): "))
            AS -= S1
            if AS == 0:
                print(bcolors.FAIL + "Du hast das letzte Streichholz genommen und verlierst" + bcolors.RESET)
                print(bcolors.OK + "Die KI hat somit gewonnen" + bcolors.RESET)
            
            if schwierigkeit == "leicht":
                SK = leicht(AS)
            elif schwierigkeit == "mittel":    
                SK = mittel(AS)
            else:
               SK = schwer(AS)
            
            print()
            print(bcolors.OK + "Die KI nimmt "+ str(SK) + " Streichhölzer" + bcolors.RESET)
            
            AS -= SK
            if AS == 0:
                print(bcolors.FAIL + "Die KI hat das letzte Streichholz genommen und verliert" + bcolors.RESET)
                print(bcolors.OK + "Du hast somit gewonnen" + bcolors.RESET)
            

Streichholzspiel()