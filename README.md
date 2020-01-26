# LeboncoinTest

Affichage de la météo locale, avec Infoclimat.

## Explications

* MVVM standard avec un business layer sous forme de gestionnaire de données (ForecastManager) utilisant un utilitaire réseau (NetworkService), utilitaire de stockage (StorageService) et un utilitaire de localisation (LocalisationService).
* Exemple d’utilisation d’un pattern Strategy (NetworkService, StorageService, LocalisationService) pour définir quel type et donc quelle stratégie de service utiliser (exemple avec les services AlamofireNetwork, JustNetwork - qui ne sont pas implémentés).
* Utilisation partielle de [RxSwift](https://github.com/ReactiveX/RxSwift) permettant une déclaration de séquences symbolisant les traitements asynchrones de manière séquentielle.
* Utilisation des [NSAttributedString](https://developer.apple.com/documentation/foundation/nsattributedstring) et [NSMutableString](https://developer.apple.com/documentation/foundation/nsmutablestring)
