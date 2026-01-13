= Conclusion <conclusion>

Finalement, le projet s'est bien déroulé, comme mentionné plusieurs fois dans ce rapport, les objectifs ont été atteints. De plus, le logiciel a déjà pu être utilisé par mon professeur de TB pour aider au travail d'adaptation d'impédance dans un projet d'un étudiant, ce qui était beaucoup plus rapide que si on utilisait l'outil Smith.exe selon ses dires. 

Le véritable atout que JSmithFX a par rapport à Smith.exe est qu'il permet une visualisation en direct des éléments lors de l'adaptation avec des fichiers S1P. Il est nettement plus simple d'optimiser les composants pour que les plages de fréquences choisies se trouvent vers le centre de l'abaque.

Au niveau des performances, le système de debouncing et la gestion optimisée du redessin permettent une navigation fluide même avec des circuits complexes ou des fichiers S1P contenant des milliers de points. Même si l'optimisation pourrait être encore plus poussée, les performances sont bonnes. Le choix de JavaFX n'a pas posé de problème, la bibliothèque s'est révélée stable et l'utilisation des propriétés observables qu'elle met à disposition était très utile.

Côté technique, les challenges les plus intéressants étaient le calcul des trajectoires des composants avec pertes et la modélisation des lignes de transmission. Essayer de concevoir du code le plus réutilisable possible était aussi assez complexe. Même maintenant, le code n'est pas le plus propre, notamment avec des classes qui pourraient être encore plus spécialisées et donc amener plus d'ordre au code. 

Par rapport à la planification, elle a été plus ou moins suivie, avec un peu d'avance au début du projet, avance que j'ai perdue sur la fin, mais toutes les fonctionnalités ont pu être mises en place.

Ensuite, pour des améliorations futures, je pense que ce projet pourrait avoir des fonctionnalités supplémentaires, comme une meilleure gestion des facteurs de qualité selon la fréquence, l'utilisation de fichiers S2P (paramètres S à deux ports), un meilleur système de dessin pour les éléments avec perte où il existe sûrement une meilleure façon de dessiner ces telles courbes, ou encore peut-être un ajout d'algorithme de résolution automatique de circuits d'adaptation.

Au final, JSmithFX remplit totalement son objectif, qui est de fournir un outil moderne, multi-plateforme et intuitif pour l'adaptation d'impédance. Le fait qu'il ait déjà été utilisé pour un vrai projet montre que ça répond à un vrai besoin. 
