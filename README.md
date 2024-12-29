DONE:
1) implemeted all the controllers, both for regulation and for tracking
2) obstacle avoidance, using sensor (offline implementation)
3) parking
4) add sharp corners to test criticisms of some controllers
5) online version for obstacle avoidance

TODO:
1) test the performance of all controllers (traj+regul)
2) test obstacle avoidance in different spots on the circuit
3) full path for parking (possibile S shape ?)
4) tuning gains for each controller
5) PRO version: moving obstacle avoidance

PRESENTATION:
1) contesto: spiegare obiettivo del lavoro , uniycle, obstacle e tracking
   obiettivo: seguire un circuito , evitare ostacolo e parcheggiare
   applicazione: controllo di uniycle per tracking and parking , obstacle
   1- creato il circuito
   2- follow della traiettoria --> primi 4 controllori
   3- traiettoria con obstacle avoidance --> primi 4 controllori
   3- parking --> 3 regolatori
   
   

1) circuito , come creato, perchè creato , evidenziare problematiche per i controllori  , foto traiettoria e tuto TODO per i pro: shiftare per avere il parcheggio in (0,0)
2) tracking senza ostacolo: gli spieghiamo i 4 controllori (state error con i plot // output error con i loro plot)
3) ostacolo function block ....
5) parcheggio, regolatori

importante mettere: immaigni di simulink, function block se importante, nei controlli alcuni gain sono satturati 
RICCARDO: diff.flat
THOMAS:  FEEDBACK YD,ZD  +  REGOL
ALE: CIRUCITO OSTACOLI SENSORI ...

