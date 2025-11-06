= État de l'art <etatdelart>

== Fonctionnalités souhaitées

Le but de ce projet est de proposer un outil moderne et complet pour l'utilisation de l'abaque de Smith. Parmi les fonctionnalités attendues, il doit être possible d'éditer plusieurs circuits par projet, et non pas être limité à un seul.


== Logiciel déjà existant (Pas sûr si pertinant d'en parler)

L'idée initiale de ce travail de bachelor est de moderniser l'outil existant développé par Fritz Dellsperger, sur lequel s'appuient actuellement les étudiants pour leurs laboratoires. Le produit final s'en inspirera largement tout en cherchant à corriger ses principales limites et en ajoutant les nouvelles fonctionnalités souhaitées.

=== Smith (Smith.exe)

Smith, ou plus couramment *Smith.exe*, est un logiciel dont la dernière mise à jour date de 2018. Il fonctionne uniquement sous Windows.

#figure(image("../template/images/smithexe/apercu.png", width:70%), caption: [Aperçu de Smith.exe])

Le principal problème de ce logiciel est son absence de support sur d'autres plateformes comme Linux ou macOS. Son ergonomie, basée sur un système de sous-fenêtres daté, rend son utilisation peu intuitive. De plus, plusieurs fonctionnalités manquent par rapport aux besoins définis pour ce projet.

== Bibliothèques et frameworks graphiques pour applications multiplateformes

Afin de développer une application moderne et accessible sur plusieurs systèmes d'exploitation, il est important de choisir des technologies adaptées. Cette section présente une analyse des principaux frameworks et bibliothèques permettant la création d'interfaces graphiques multiplateformes.

Dans le cadre de ce projet, le public cible étant constitué d'étudiants et d'ingénieur, le choix technologique doit répondre à plusieurs exigences. L'application doit avant tout être multiplateforme afin d'assurer une compatibilité avec Windows, macOS et Linux. Elle doit également être moderne visuellement, de manière à offrir une interface intuitive et agréable à utiliser. Enfin, elle doit rester performante pour garantir une expérience fluide, même sur des machines pas très performante.

Ces trois critères serviront de base pour évaluer les différentes solutions envisagées dans la suite de ce travail.

=== Qt (C++/Python)

Qt est un framework multiplateforme très répandu, utilisé tout aussi bien dans l'industrie que dans le monde académique. Il offre une excellente performance, une interface native sur chaque système et il possède une large communauté active.  

Le fait que Qt puisse être utilisé en C++ ou en Python est un avantage, bien que Python puisse poser des limites de performance dans le cadre de calculs intensifs. Je n'ai encore jamais utilisé Qt, mais c'est un candidat serieux que ne demande qu'a être testé.

=== JavaFX

JavaFX est un framework de développement d'application multiplateforme vu qu'il utilise java qui lui même est multiplateforme grace à la sainte JVM. C'est un framework très complet avec beaucoup de widgets pre existant créé par la communauté : https://github.com/palexdev/MaterialFX, https://github.com/mkpaz/atlantafx et d'autres.

C'est très important pour avoir une interface qui soit moderne et plaisante à utiliser. 

L'utilisation de java est bon tout aussi vu que java est multiplateforme de base, pas besoin de trop s'embêter et question performance java dans ses dernières version est très performant car nous avions pu l'utiliser pour faire des simulations assez rapide dans le cadre du cours donné par J.F Hêches nommé optimisation et simulation.

Finalement un test a pu être effectué et la prise en main de JavaFX semble être adaptée pour le projet.


=== GTK

GTK, anciennement GIMP ToolKit est un toolkit qui permet d'effectuer des GUI majoritairement sur Linux mais est aussi compatible avec Windows et MacOS. C'est un outil très utilisé dans la communauté Linux, son avantage est que sa librairie fonctionne avec plusieurs language différent, C, Javascript, Perl, Python, Rust, etc...

Cela peut-être une bonne alternative même s'il est possible que le support soit limité sur les plateforme autre que Linux.

=== Flutter

Flutter est un framework créé par Google pour faire des applications multiplateformes. D'après les retours sur Reddit et ailleurs, Flutter a l'air solide avec des APIs matures et un bon rendu graphique.

Le principal frein est que ça utilise le langage Dart, que je ne connais pas du tout. En plus, Flutter a été pensé d'abord pour le mobile, le support desktop étant quelque chose de plus récent même si apparemment bien supporté. 


=== Tauri (Rust)

Tauri est un framework qui utilise une architecture du type web pour le frontend et un backend en Rust. Vu que l'application tourne en backend avec Rust et en frontend avec une technologie web tel que React, Vue, etc. Ce choix peut-être le bon vu que ça peut être une bonne introduction à Rust et l'utilisation de technologie Web m'est plus que familier.

Un grand plus de ce framework est aussi la performance et sa moindre emprunte mémoire.

Après avoir fait quelques recherche, je vois que si je veux faire quelque chose de graphique avec Tauri comme dessiner l'abaque de Smith, je vais sûrement devoir utiliser une libraire js pour le faire, ce qui ne m'enchante pas beaucoup... De plus, le backend ne sera pas très complexe dans ce projet or, avec Tauri, toute la partie graphique doit être réalisée en JavaScript via une technologie web (React, Vue, etc.), ce qui ajoute une couche supplémentaire et ne me semble pas pertinent ici. Je préférerais une solution où le dessin et l'interactivité sont gérés directement dans le langage principal du framework et qui n'utilise si possible pas de Javascript 

== Choix et justification

Pas encore de choix :( 