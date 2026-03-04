# Soleil Cut-in Module ⚡

Un module Godot 4 dédié à la création d'animations de superposition d'écran dramatiques (les fameux "Cut-ins", "Super Arts", ou "Screen Takeovers" très présents dans les JRPG et les jeux de combat visuellement intenses). 

Ce système est conçu avec la philosophie **Data-Driven** (Piloté par les données) pour garantir une réutilisation maximale sans dupliquer les scènes complexes d'animation.

## 🏗️ Architecture (Ressources + Fabriques)

Le module sépare strictement *l'Animation* (la scène générique programmée avec des courbes parfaites) des *Données* (les couleurs et le visage du personnage qui font l'attaque).

```mermaid
graph TD
    subgraph Data Vos Assets
        HeroTres[hero_cutin.tres]
        EnemyTres[enemy_cutin.tres]
    end

    subgraph SoleilCutins Autoload La Fabrique
        Singleton[Singleton Global<br>Z-Index: 100]
    end

    subgraph Factory Scenes Animées
        T1[horizontal_slash_cutin.tscn]
        T2[vertical_poster_cutin.tscn]
    end
    
    HeroTres -.-> |Passé en argument| Singleton
    Singleton --> |Instancie & Injecte Data| T1
    Singleton --> |Instancie & Injecte Data| T2
    
    style Singleton fill:#154a87,stroke:#333,color:#fff
    style T1 fill:#2a3a4a,stroke:#333,color:#fff
    style T2 fill:#2a3a4a,stroke:#333,color:#fff
    style HeroTres fill:#875615,stroke:#333,color:#fff
```

L'Autoload vit sur un `CanvasLayer` situé bien au-dessus de tout le reste du jeu, s'assurant que l'animation ne soit jamais dissimulée par une caméra de niveau ou l'interface standard.

---

## 📦 Installation (Git Submodule)

Installez ce module en tant que sous-module Git pour pouvoir bénéficier des ajouts de nouvelles animations de cut-in par la suite !

1. À la racine de votre projet Git, ouvrez un terminal et exécutez la commande suivante :
   ```bash
   git submodule add https://github.com/MarioTheKnight/soleil-cutin.git addons/soleil_cutin
   ```
2. Ouvrez votre projet dans l'éditeur Godot.
3. Allez dans **Projet > Paramètres du projet > Extensions (Plugins)**.
4. Cochez **Activé** à côté de "Soleil Cutins".
5. L'Autoload `SoleilCutins` sera automatiquement enregistré.

---

## 🎨 Utilisation depuis l'Éditeur (Créer une attaque)

Avant de coder quoi que ce soit, vous devez définir concrètement les visuels d'une attaque en créant une **Ressource** :

1. Dans votre dossier racine `assets/`, faites clic droit > **Créer un nouveau... > Ressource**.
2. Recherchez et choisissez le type **`CutinData`**.
3. Nommez-le (ex: `hero_fireball.tres`).
4. Dans l'inspecteur à droite, glissez-déposez le portrait dessiné du héros, choisissez la couleur de fond du bandeau (ex: Rouge), la couleur du texte et tapez le nom de l'attaque.

*C'est fini pour la partie artistique ! Vous pouvez créer 50 .tres différents pour vos 50 personnages sans avoir besoin d'assembler la moindre scène.*

---

## 💻 Utilisation Programatique (GDScript)

Une fois vos fichiers `.tres` préparés, l'invocation se fait en une seule ligne depuis le code de combat de votre jeu !

### Invoquer un Cut-in

1. Pointez vers votre ressource `.tres` d'une façon ou d'une autre (exposée ou pré-chargée).
2. Appelez `SoleilCutins.play_cutin(...)` en passant le style d'animation désiré et les données.

```gdscript
extends CharacterBody2D

# 1. Le Game Designer glisse `hero_fireball.tres` dans l'inspecteur ici !
@export var my_special_attack_data: CutinData 

func use_ultimate_skill():
    # 2. On lance l'animation par-dessus l'écran
    #    ("horizontal_slash" ou "vertical_poster")
    SoleilCutins.play_cutin("horizontal_slash", my_special_attack_data)
    
    # ...
    # Insérez ici la logique du jeu (figer le temps, infliger des dégâts)
    print("Dégâts massifs infligés !")
```

> **🔥 Pro-Tip : Intégration SoleilMotion**
> Si le plugin `soleil_motion` est également installé et actif sur votre projet, les cut-ins secoueront la caméra (`Camera2D`) active du viewport de manière intense lors de certains moments clés de l'animation ! L'intégration est automatique.

---

## 📂 Organisation Recommandée des Fichiers

```text
MonSuperJeu/
├── addons/
│   ├── soleil_cutin/       <-- Le code et les scènes complexes (ne pas toucher)
│   └── soleil_motion/
├── assets/
│   ├── characters/
│   │   ├── hero/
│   │   │   ├── hero_sprite.png
│   │   │   ├── hero_portrait_huge.png    <-- Pour la ressource
│   │   │   └── hero_cutin_style1.tres    <-- La ressource CutinData
│   │   └── boss/
│   │       ├── boss_sprite.png
│   │       ├── boss_angry_portrait.png   <-- Pour la ressource
│   │       └── boss_cutin_phase2.tres    <-- La ressource CutinData
```
