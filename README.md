# Progetto elaborazione delle immagini 2019/2020

* Questa applicazione è un ipotetico controllo di qualità del
  confezionamento di scatole di cioccolatini.
* L’applicazione data una fotografia di una scatola di cioccolatini ne valuta la sua
  conformità e ne mostra gli eventuali errori.
* Per questo progetto le uniche scatole di cioccolatini considerate sono le seguenti:
  
  ![Screenshot_2020-02-22_13-04-49](https://user-images.githubusercontent.com/19750893/111160424-61f78000-859a-11eb-8c1e-7bedd4b7f8d6.png)
  ![Screenshot_2020-02-22_13-04-13](https://user-images.githubusercontent.com/19750893/111160551-7d628b00-859a-11eb-92ee-69914b113dc0.png)

# Una scatola NON è conforme se:

* Mancano dei cioccolatini.
* I cioccolatini sono in posizione non corretta.
* Mancano i bollini sui cioccolatini (esclusivamente i ferrero rocher).
* Ci sono degli elementi estranei nella scatola.
* (La presenza all’esterno della scatola di oggetti NON influenza la conformità della scatola).

# Risultato classificazione

![Screenshot_2020-02-22_13-33-20](https://user-images.githubusercontent.com/19750893/111160755-b0a51a00-859a-11eb-8441-a499101b5b1c.png)
![Screenshot_2020-02-22_13-34-02](https://user-images.githubusercontent.com/19750893/111160775-b69afb00-859a-11eb-8882-f87de2d17794.png)

# Visualizzazione eventuali errori

![Screenshot_2020-02-22_13-33-42](https://user-images.githubusercontent.com/19750893/111160825-c61a4400-859a-11eb-834c-258e14554ca0.png)

# Implementazione Matlab

* main.m - contiene la funzione che data un immagine ritorna la conformità.
* maintest.m - valuta la conformità di tutte le immagini.
* +classification - contiene una serie di script e funzioni per la classificazione.
* +utils - funzioni utili (comprese quelle oer il calcolo delle features).
* +classification/trainchoco.m e +classification/trainshape.m - eseguono il training dei classificatori e la valutazione (matrice di confuzione).
