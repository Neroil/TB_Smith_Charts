= État de l'art <etatdelart>

== Fonctionnalitées voulue
- Pouvoir éditer plusieurs circuits par projet et non être bloqué sur un seul circuit.
- 


== Logiciel déjà existant (Pas sûr si pertinant d'en parler)

L'idée intiale de ce travail de bachelor est de moderniser l'outil existant développé par Fritz Dellsperger et le produit final s'en inspirera grandement. 

=== Smith

Smith ou communement appelé Smith.exe est un logiciel dernièrement mis à jour en 2018 et qui tourne nativement sous Windows. 

#figure(image("../template/images/smithexe/apercu.png", width:70%),
caption: [Smith exe dans toute sa splendeur])

Le problème avec ce logiciel est son manque de support sur d'autres plateforme (Linux et MacOS). L'ergonomie qui laisse à désirer avec son système de sous fenêtre datée et ses fonctionnalités manquante par rapport aux fonctionnalité voulue.


== Bibliothèques et frameworks graphiques pour applications multiplateformes

Afin de développer une application moderne et accessible sur plusieurs systèmes d'exploitation, il est essentiel de choisir des technologies adaptées. Cette section présente une analyse des principaux frameworks et bibliothèques permettant la création d'interfaces graphiques multiplateformes.

Dans le cadre de ce projet, le public cible étant constitué d'étudiants, le choix technologique doit répondre à plusieurs exigences. L'application doit avant tout être multiplateforme afin d'assurer une compatibilité avec Windows, macOS et Linux. Elle doit également être moderne visuellement, de manière à offrir une interface intuitive et agréable à utiliser. Enfin, elle doit rester performante pour garantir une expérience fluide, même sur des machines pas très performante.

Ces trois critères serviront de base pour évaluer les différentes solutions envisagées dans la suite de ce travail.

=== Qt (C++/Python)

Qt est un framework multiplateforme très utilisé dans le monde entier. C++ est aussi un langage qui m'est familié et qui est très performant donc ça ne serait pas problématique d'utiliser. Vu que c'est très utilisé, il y a beaucoup de documentation et des plugins customs par ci par là. A tester car je n'ai jamais utilisé QT auparavant.

Ensuite il y a la question de s'il vaut mieux utiliser python ou c++. Vu que le but est d'avoir un logiciel qui soit performant, prendre python semble ne pas être le bon choix mais des tests sont à effectuer. 

=== JavaFX

JavaFX est un framework de développement d'application multiplateforme vu qu'il utilise java qui lui même est multiplateforme grace à la sainte JVM. C'est un framework très complet avec beaucoup de widgets pre existant créé par la communauté : https://github.com/palexdev/MaterialFX, https://github.com/mkpaz/atlantafx et d'autres.

C'est très important pour avoir une interface qui soit moderne et plaisante à utiliser. 

L'utilisation de java est bon tout aussi vu que java est multiplateforme de base, pas besoin de trop s'embêter et question performance java dans ses dernières version est très performant (il faut encore faire des tests)

== Choix et justification

Pas encore de choix :( 