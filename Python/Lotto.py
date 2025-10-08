import random
alle_Lottozahlen = []
alle_Lottozahlen.extend(range(1,50))
Lottozahlen_Gewinner = random.sample(alle_Lottozahlen, 6)
Lottozahlen_Gewinner.sort()
print(Lottozahlen_Gewinner)