= État de l'art <etatdelart>

== Fonctionnalités souhaitées

Le but de ce projet est de proposer un outil moderne et complet pour l'utilisation de l'abaque de Smith. Parmi les fonctionnalités attendues, il doit être possible d'éditer plusieurs circuits par projet, et non pas être limité à un seul.


== Logiciel déjà existant

L'idée initiale de ce travail de bachelor est de moderniser l'outil existant développé par Fritz Dellsperger, sur lequel s'appuient actuellement les étudiants pour leurs laboratoires. Le produit final s'en inspirera largement tout en cherchant à corriger ses principales limites et en ajoutant les nouvelles fonctionnalités souhaitées.

=== Smith (Smith.exe)

Smith, qui sera appelé *Smith.exe* @smith_v4 dans le reste de ce rapport, est un logiciel dont la dernière mise à jour date de 2018. Il fonctionne uniquement sous Windows.

#figure(image("../template/images/smithexe/apercu.png", width:70%), caption: [Aperçu de Smith.exe])

Le principal problème de ce logiciel est son absence de support sur d'autres plateformes, comme Linux ou macOS. Son ergonomie, basée sur un système de sous-fenêtres daté, rend son utilisation peu intuitive. De plus, plusieurs fonctionnalités manquent par rapport aux besoins définis pour ce projet.

Mais, vu que le projet va largement s'inspirer de celui-ci, il est important de comprendre comment il fonctionne.

== Bibliothèques et frameworks graphiques pour applications multiplateformes

Afin de développer une application moderne et accessible sur plusieurs systèmes d'exploitation, il est important de choisir des technologies adaptées. Cette section présente une analyse des principaux frameworks et bibliothèques permettant la création d'interfaces graphiques multiplateformes.

Dans le cadre de ce projet, le public cible étant constitué d'étudiants et d'ingénieurs, le choix technologique doit répondre à plusieurs exigences. L'application doit avant tout être multiplateforme afin d'assurer une compatibilité avec Windows, macOS et Linux. Elle doit également être moderne visuellement, de manière à offrir une interface intuitive et agréable à utiliser. Enfin, elle doit rester performante pour garantir une expérience fluide, même sur des machines pas très performantes.

Ces trois critères serviront de base pour évaluer les différentes solutions envisagées dans la suite de ce travail.

=== Qt (C++/Python)

Qt est un framework multiplateforme très répandu, utilisé tout aussi bien dans l'industrie que dans le monde académique. Il offre une excellente performance, une interface native sur chaque système et il possède une large communauté active.  

Le fait que Qt puisse être utilisé en C++ ou en Python est un avantage, bien que Python puisse poser des limites de performance dans le cadre de calculs intensifs. 

Après quelques essais, l'interface graphique de Qt Designer et les modules de dessins de Qt semblent être vraiment bien adaptés au projet. Le seul mauvais point notable est que, pour pouvoir compiler de façon multiplateforme, il faut disposer de différentes machines sur lesquelles compiler. C'est-à-dire avoir une machine Windows, Linux (avec ses différents distro) et MacOS. Ce n'est pas un problème avec les machines virtuelles, mais cela représente tout de même un frein, surtout que l'affichage pourrait ne pas être exactement le même selon sur quel OS le logiciel final tourne.

=== JavaFX


JavaFX est un framework de développement d'applications multiplateforme, puisqu'il repose sur Java et sa fameuse Machine virtuelle (JVM), fidèle au slogan "Write once, run anywhere".

C'est aussi un framework très complet, enrichi par une communauté active qui propose de nombreux composants graphiques prêts à l'emploi (comme MaterialFX @materialfx ou AtlantaFX @atlantafx ). C'est un atout majeur pour obtenir facilement une interface moderne et agréable à utiliser.

L'un des plus grands avantages de Java, c'est qu'il est multiplateforme par nature. Pas besoin de s'embêter avec la cross compilation, on produit un seul fichier qui fonctionnera partout où la JVM est installée, et quasiment tout appareil a Java d'installé. \
Et question performance, les dernières versions de Java sont très efficaces. On a pu le constater en réalisant des simulations de recherche de chemin optimum dans des graphes dans le cadre du cours "Optimisation et Simulation" donné par J.F. Hêches.

Finalement, après un premier test, la prise en main de JavaFX s'est révélée intuitive et bien adaptée aux besoins du projet.


=== GTK

GTK, anciennement GIMP ToolKit est un toolkit qui permet d'effectuer des GUI majoritairement sur Linux, mais est aussi compatible avec Windows et MacOS. C'est un outil très utilisé dans la communauté Linux, son avantage est que sa librairie fonctionne avec plusieurs langages différents, C, JavaScript, Perl, Python, Rust, etc...

Cela peut-être une bonne alternative, même s'il est possible que le support soit limité sur les plateformes autres que Linux.

=== Flutter

Flutter est un framework créé par Google pour faire des applications multiplateformes. D'après les retours sur Reddit et ailleurs, Flutter a l'air solide avec des APIs matures et un bon rendu graphique.

Le principal frein est que le langage utilisé est le Dart. L'apprentissage d'un nouveau langage représenterait une charge non négligeable au travail. En plus, Flutter a été pensé d'abord pour le mobile, le support desktop étant quelque chose de plus récent, même si apparemment bien supporté.

De plus, une considération par rapport au projet est la maintenabilité future. Lorsque mon projet sera terminé, sûrement d'autres étudiants ou même ingénieurs seront susceptibles d'ajouter de nouvelles fonctionnalités. Sachant que le logiciel est destiné aux ingénieurs en électrique, il vaudrait mieux se focaliser sur une solution utilisant des langages avec lesquels ils sont déjà à l'aise, le C, le C++ et possiblement le Java. 

=== Tauri (Rust)

Tauri est un framework qui utilise une architecture du type web pour le frontend et un backend en Rust. Vu que l'application tourne en backend avec Rust et en frontend avec une technologie web tel que React, Vue, etc. Ce choix peut-être le bon vu que ça peut être un bon entraînement à Rust et l'utilisation de technologie Web m'est plus que familière.

Un grand plus de ce framework est aussi la performance et sa moindre empreinte mémoire.

Après avoir fait quelques recherches, on peut voir que, si l'on veut faire quelque chose de graphique avec Tauri comme dessiner l'abaque de Smith, l'utilisation d'une bibliothèque JavaScript est obligatoire pour le faire, ce qui pose un grand frein pour l'adaptation de ce framework. De plus, le backend ne sera pas très complexe dans ce projet or, avec Tauri, toute la partie graphique doit être réalisée en JavaScript via une technologie web (React, Vue, etc.), ce qui ajoute une couche supplémentaire et ne semble pas pertinent ici. Une solution où le dessin et l'interactivité sont gérés directement dans le langage principal du framework et qui n'utilise si possible pas de JavaScript est préférable. 

== Choix et justification

Finalement, après avoir passé en revue ces différents frameworks, ce qui semble le plus adapté pour l'envergure de ce travail de bachelor reste JavaFX. 

Qt était un bon concurrent, de par sa performance et sa maturité. Mais le problème de déploiement, de compilation multi-plateforme représente un obstacle trop important pour un projet solo mené dans un temps limité. Trop de temps serait potentiellement perdu lorsqu'une compilation devrait être fait.

C'est la raison pour laquelle l'utilisation de Java est logique ici, pas besoin de se focaliser sur la compilation, juste besoin de produire un seul exécutable compatible avec toutes les machines, tant qu'elles ont Java d'installé. 

Les autres solutions ont été écartées, car soit le langage n'était pas adapté aux besoins qui dépassent l'étendue de ce TB, notamment si le travail est repris par d'autres étudiants de la filière électrique. 

Donc, en conclusion, le projet d'abaque de Smith sera codé en utilisant du Java et en utilisant le framework JavaFX, qui est plus que suffisant pour l'étendue de ce travail.

== Bibliothèque de sérialisation

Lors de la conception, un choix a dû être fait concernant la bibliothèque de sérialisation pour permettre de sauvegarder et charger les projets (les composants du circuit, la fréquence, etc.).

Mon choix s'est rapidement porté sur Jackson. C'est une bibliothèque que j'avais déjà utilisée sur d'autres projets, ce qui m'a permis d'être efficace sans avoir à réaliser un comparatif exhaustif avec d'autres solutions. Elle est simple d'utilisation, toujours activement maintenue, et la vitesse de sérialisation n'était pas un critère critique pour ce projet donc pas besoin de faire des tests par rapport à cela.

De plus, Jackson s'est révélé particulièrement adapté grâce à sa gestion facile du polymorphisme, pas besoin de grandement changer le code pour que cela fonctionne. Cela m'a permis de sauvegarder ma liste de composants variés (Résistances, Lignes, Condensateurs, ...) très simplement, sans avoir à écrire de code complexe pour différencier chaque type d'objet dans le fichier de sauvegarde.