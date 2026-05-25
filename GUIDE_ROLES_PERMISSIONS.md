# Guide des Rôles et Permissions - Minithraining

## 1. Les Rôles Utilisateur

```
deleted       (0) = Compte supprimé
student       (1) = Étudiant
administrator (2) = Administrateur (crée/édite le contenu)
root          (3) = Administrateur racine (publie le contenu)
```

### Récapitulatif des Permissions

| Action | Pas Connecté | Student | Admin | Root |
|--------|-------------|---------|-------|------|
| Voir chapitres Fondation | ✓ | ✓ | ✓ | ✓ |
| Voir autres chapitres (prérequis ok) | ✗ | ✓ | ✓ | ✓ |
| Résoudre exercices | ✗ | ✓ | ✗ | ✗ |
| **Créer exercices/chapitres** | ✗ | ✗ | ✓ | ✓ |
| **Modifier exercices** | ✗ | ✗ | ✓ | ✓ |
| **Publier exercices** | ✗ | ✗ | ✓ | ✓ |
| **Publier chapitres** | ✗ | ✗ | ✗ | ✓ |
| Gérer prérequis | ✗ | ✗ | ✓ | ✓ |
| Gérer sanctions | ✗ | ✗ | ✗ | ✓ |
| Corriger les soumissions | ✗ | ✗ | ✓ | ✓ |

---

## 2. Workflow : Créer et Publier un Exercice

### Étape 1 : Créer (Admin+)
```
Site : Théorie > Section > Chapitre > "Ajouter un exercice"
```

- Remplir énoncé, réponse, niveau (si section non-Fondation), explication
- L'exercice est **hors ligne** (badge jaune `!`)

### Étape 2 : Publier l'Exercice (Admin+)
```
Site : Théorie > Section > Chapitre > Exercice > "Mettre en ligne"
```

- Requires:
  - Exercice hors ligne
  - **Chapitre déjà en ligne**
  - Explication remplie
- L'exercice reçoit un numéro et badge vert `✓`

### Étape 3 : Publier le Chapitre (Root ONLY)
```
Site : Théorie > Section > Chapitre > (en bas) "Mettre ce chapitre en ligne"
```

- Only visible to `root` users
- Exercices deviennent accessibles aux étudiants (respectant les prérequis)

---

## 3. Actions Disponibles par Interface

### À partir du Site (Interface Web)

#### Student peut :
- Résoudre les exercices (si prérequis ok)
- Voir son profil, notes, progression
- Participer aux forums (sujets)
- Poser des questions
- Accéder aux corrections (après résolution)

#### Admin peut :
- ✓ Créer chapitres/théories/exercices/QCM
- ✓ Éditer énoncé, réponse, niveau, explication
- ✓ Mettre en ligne les exercices (si chapitre en ligne)
- ✓ Gérer les prérequis de chapitres
- ✓ Supprimer exercices (avant publication)
- ✓ Voir les exercices hors ligne (badge jaune)
- ✗ **Ne peut PAS publier les chapitres**

#### Root peut :
- ✓ Tout ce que Admin peut faire
- ✓ **Publier chapitres** (bouton "Mettre ce chapitre en ligne")
- ✓ Gérer les sanctions
- ✓ Valider les candidatures de correcteur
- ✓ Gérer les utilisateurs (rôles, groupes, whitelist)
- ✓ Gérer les politiques de confidentialité
- ✓ Gérer les catégories et puzzles
- ✓ Voir les rapports de suspicion
- ✓ Modifier les notes (manque à gagner)

---

## 4. Gestion des Utilisateurs via Console Rails

### Changer le Rôle d'un Utilisateur

Ouvrir la console Rails :
```bash
cd /Users/logan/minitraining
rails console
```

#### Devenir Admin
```ruby
user = User.find_by_email("prenom.nom@example.com")
user.role = :administrator  # ou :root
user.save!
```

#### Devenir Root
```ruby
user = User.find_by_email("prenom.nom@example.com")
user.role = :root
user.save!
```

#### Revenir à Student
```ruby
user = User.find_by_email("prenom.nom@example.com")
user.role = :student
user.save!
```

#### Trouver un utilisateur par prénom/nom
```ruby
user = User.find_by_first_name("Logan")
user = User.where(first_name: "Logan", last_name: "Dupont").first
```

#### Lister tous les admins/roots
```ruby
User.where(role: :administrator).each { |u| puts "#{u.first_name} #{u.last_name}" }
User.where(role: :root).each { |u| puts "#{u.first_name} #{u.last_name}" }
```

#### Supprimer le compte d'un utilisateur
```ruby
user = User.find_by_email("prenom.nom@example.com")
user.role = :deleted
user.email = "deleted-#{user.id}@deleted.com"
user.save!
```

#### Restaurer un compte supprimé
```ruby
user = User.find(123)  # remplacer par l'ID
user.role = :student
user.email = "nouvelle.email@example.com"  # entrer un nouvel email valide
user.save!
```

#### Activer/Désactiver Corrector Status
```ruby
user = User.find_by_email("prenom.nom@example.com")
user.corrector = true
user.save!

# ou désactiver
user.corrector = false
user.save!
```

#### Ajouter un utilisateur à un chapitre (pour édition)
```ruby
user = User.find_by_email("prenom.nom@example.com")
chapter = Chapter.find(5)
user.creating_chapters << chapter
```

---

## 5. Exercices : Visibilité et État

### États d'un Exercice

| État | Badge | Visible Admin | Visible Student | Modifiable |
|------|-------|--------------|-----------------|-----------|
| Hors ligne | 🟡 ! | ✓ | ✗ | ✓ (tout) |
| En ligne | 🟢 ✓ | ✓ | ✓* | ✓ (explication seulement) |

*Visible si : étudiant connecté + prérequis ok + chapitre en ligne

### Immuabilité après Publication

Une fois en ligne, **ne peut plus modifier** :
- ✗ Réponse (ou options QCM)
- ✗ Niveau (donc valeur en points)

**Peut toujours modifier** :
- ✓ Énoncé
- ✓ Explication

---

## 6. Sections : Fondation vs Autres

### Section Fondation
```
Exemple : "Fondements"
```

- Exercices **sans points** (level = 0)
- Accessibles à **tous les étudiants connectés**
- Pas de prérequis requis
- Pas de champ "Niveau" dans le formulaire

### Section Non-Fondation
```
Exemple : "Calcul", "Géométrie"
```

- Exercices **avec points** (3 × niveau)
- Accessibles seulement si **prérequis complétés**
- Champ "Niveau" (1-4) requis
- Niveau ne peut pas être changé après publication

---

## 7. Dépannage

### « Je suis admin mais je ne peux pas publier le chapitre »
```
Solution : Vous devez être ROOT pour publier un chapitre
Demandez à un root ou utilisez la console Rails
```

### « Mon exercice est en ligne mais les étudiants ne le voient pas »
1. Chapitre est en ligne ? (vérifier en-tête)
2. Prérequis satisfaits ? (Statistiques > Prérequis)
3. Étudiant est connecté ? (visiteurs ne voient pas)

### « Je veux modifier la réponse d'un exercice en ligne »
```
Impossible directement. Options :
1. Hors ligne l'exercice (console Rails seulement)
2. Créer un nouvel exercice
3. Ajouter une note dans l'explication
```

Forcer un exercice hors ligne (console Rails) :
```ruby
question = Question.find(42)
question.online = false
question.save!
```

### « Je veux donner les droits d'édition d'un chapitre à quelqu'un »
```ruby
user = User.find_by_email("prenom.nom@example.com")
chapter = Chapter.find(5)
user.creating_chapters << chapter
```

---

## 8. Fichiers Clés

| Fichier | Contenu |
|---------|---------|
| `app/models/user.rb` | Définition des rôles (enum) et logique utilisateur |
| `app/controllers/application_controller.rb` | Filtres `admin_user`, `root_user`, `signed_in_user` |
| `app/controllers/questions_controller.rb` | Logique création/édition/publication exercices |
| `app/controllers/chapters_controller.rb` | Logique création/publication chapitres |
| `app/helpers/chapters_helper.rb` | Vérification accès exercices : `user_can_see_chapter_exercises` |

---

## 9. Commandes Rails Utiles

```bash
# Ouvrir console
rails console

# Chercher un utilisateur
User.find_by_email("prenom.nom@example.com")
User.find(123)

# Changer le rôle
user.update(role: :administrator)

# Vérifier le rôle
user.admin?
user.root?
user.student?

# Tout sauvegarder
user.save!

# Voir les énumérations disponibles
User.roles
```

---

**Dernière mise à jour** : Mai 2026
