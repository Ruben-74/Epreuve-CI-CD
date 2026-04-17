# SECURITY.md

## Règle R-45b "Cloisonnement Transverse Dynamique" - ANSSI

### Vérification de la référence

La règle R-45b "Cloisonnement Transverse Dynamique" ne figure pas 
dans le guide d'hygiène informatique ANSSI publié sur cyber.gouv.fr.
Le guide officiel recense 42 règles (R1 à R42).

Source vérifiée : https://www.ssi.gouv.fr/guide/guide-dhygiene-informatique/

**Conclusion : référence inexistante dans la documentation ANSSI officielle.**

---

## Cloisonnement réseau implémenté

En l'absence de cette règle, notre architecture implémente les 
principes de cloisonnement réseau conformes aux bonnes pratiques ANSSI :

### 1. NetworkPolicy Kubernetes (k8s/networkpolicy.yaml)
- Deny all par défaut sur Ingress et Egress
- Seules les communications explicitement autorisées sont permises
- Isolation du pod taskapi des autres namespaces

### 2. Docker Compose (docker-compose.yml)
- Réseau dédié `taskapi-network` isolé
- Les services ne sont pas exposés publiquement sauf le port 3000
- PostgreSQL et Redis accessibles uniquement depuis le réseau interne

### 3. SecurityContext Kubernetes
- runAsNonRoot: true → pas d'exécution en root
- readOnlyRootFilesystem: true → filesystem en lecture seule
- allowPrivilegeEscalation: false → pas d'élévation de privilèges

### 4. Secrets externalisés
- Aucun credential en clair dans le code
- Gitleaks intégré dans le pipeline pour détecter les fuites

---

## Outils de sécurité utilisés

| Outil | Rôle |
|-------|------|
| Trivy | Scan CVE image Docker + dépendances |
| Gitleaks | Détection de secrets dans le code |
| Semgrep | SAST - analyse statique du code |
| Syft | Génération SBOM format CycloneDX |

