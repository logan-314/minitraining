# Guide Rapide : Créer et Publier des Exercices

**Pour la description complète des rôles et permissions, voir [GUIDE_ROLES_PERMISSIONS.md](GUIDE_ROLES_PERMISSIONS.md)**

---

## Workflow Complet

### 1️⃣ Créer l'Exercice (Admin+)

```
Théorie > Section > Chapitre > "Ajouter un exercice" ou "QCM"
```

**Remplir le formulaire** :
- **Énoncé** : la question (formatage, images possibles)
- **Réponse** : valeur numérique ou options QCM
- **Niveau** : 1-4 (sauf Fondation) → valeur = 3 × niveau
- **Explication** : comment résoudre

**Statut** : 🟡 Hors ligne (brouillon)

---

### 2️⃣ Mettre en Ligne l'Exercice (Admin+)

```
Théorie > Section > Chapitre > Exercice > "Mettre en ligne"
```

**Pré-requis** :
- Chapitre doit être en ligne (vérifier en-tête : pas "(en construction)")
- Explication remplie
- Exercice hors ligne

**Après** :
- 🟢 Exercice visible pour les utilisateurs autorisés
- Reçoit un numéro (Exercice 1, 2, 3...)
- **Ne peut plus modifier** la réponse, seulement l'explication

---

### 3️⃣ Publier le Chapitre (Root ONLY)

```
Théorie > Section > Chapitre > (en bas) "Mettre ce chapitre en ligne"
```

**Important** : ce bouton n'apparaît que pour les **root**.

**Après** :
- Chapitre en ligne (en-tête sans "(en construction)")
- Exercices accessibles aux étudiants (respectant prérequis)

---

## Vérifier l'Accessibilité

### ✓ Exercice visible pour les Étudiants si :

**Et** :
- Chapitre est en ligne
- Exercice est en ligne (badge 🟢)

**Et selon la section** :
- **Fondation** : toujours accessible
- **Autre** : prérequis doivent être satisfaits

### ✗ Exercice **invisible** si :

- Exercice hors ligne (🟡)
- Chapitre hors ligne
- Prérequis non satisfaits (sections non-Fondation)
- Utilisateur non connecté (sauf aperçu Fondation)

---

## Problèmes Courants

| Problème | Cause | Solution |
|----------|-------|----------|
| Exercice visible seulement pour admin | Chapitre hors ligne | Publiez d'abord le chapitre (Root) |
| Pas de bouton "Mettre en ligne" | Admin au lieu de Root | Vous êtes admin, demandez à un root |
| Étudiant ne voit pas exercice | Prérequis manquants | Vérifiez Statistiques > Prérequis |
| Ne peux pas modifier la réponse | Exercice déjà en ligne | Créez un nouvel exercice ou utilisez console |

---

## Sections : Fondation vs Autres

| Aspect | Fondation | Autres |
|--------|-----------|--------|
| Points | 0 (pas de points) | 3 × niveau |
| Niveau | Non utilisé | 1-4 requis |
| Accès | Tous les connectés | Si prérequis ok |
| Prérequis | Pas de prérequis | Possibles |

---

## Console Rails : Commandes Utiles

Pour **changer le rôle d'un utilisateur** ou **forcer hors ligne** un exercice :

```bash
rails console
```

```ruby
# Changer le rôle d'un utilisateur
user = User.find_by_email("prenom.nom@example.com")
user.update(role: :administrator)  # ou :root, :student, :deleted

# Forcer un exercice hors ligne (pour le ré-éditer)
question = Question.find(42)
question.update(online: false)
```

**Voir [GUIDE_ROLES_PERMISSIONS.md](GUIDE_ROLES_PERMISSIONS.md) pour toutes les commandes.**

---

## Points Clés

- **Admin** : crée et édite
- **Root** : publie les chapitres
- **Niveau** : détermine les points, **immuable après publication**
- **Explication** : modifiable après publication
- **Prérequis** : gérés via Statistiques > Prérequis

---

**Pour plus de détails** : [GUIDE_ROLES_PERMISSIONS.md](GUIDE_ROLES_PERMISSIONS.md)
