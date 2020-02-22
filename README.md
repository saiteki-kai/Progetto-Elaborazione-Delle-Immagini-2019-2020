#Controllo Qualità

• Questa applicazione è un ipotetico controllo di qualità del
  confezionamento di scatole di cioccolatini
• L’applicazione data una fotografia di una scatola di cioccolatini ne valuta la sua
  conformità.
  
  ![Screenshot_2020-02-22_13-04-49](/uploads/72bd6c4de0328afff35c30a5ed853233/Screenshot_2020-02-22_13-04-49.png)
  ![Screenshot_2020-02-22_13-04-13](/uploads/c7617b95df26fc7258b057b2d624ff52/Screenshot_2020-02-22_13-04-13.png)

Una scatola NON è conforme se:
    - Mancano dei cioccolatini
    - I cioccolatini sono in posizione non corretta
    - Mancano i bollini sui cioccolatini
    - Ci sono degli elementi estranei nella scatola
    
• La presenza all’esterno della scatola di oggetti NON influenza la conformità
  della scatola

  
* main.m - contiene la funzione che data un immagine ritorna la conformità.
* maintest.m - valuta la conformità di tutte le immagini.
* +classification - contiene una serie di script e funzioni per la classificazione.
* +utils - funzioni utili (comprese quelle oer il calcolo delle features).
* +classification/trainchoco.m e +classification/trainshape.m - eseguono il training dei classificatori e la valutazione (matrice di confuzione).
