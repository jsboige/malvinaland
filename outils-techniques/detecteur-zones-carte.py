#!/usr/bin/env python3
"""
Détecteur de zones colorées pour la carte interactive de Malvinaland
Utilise la détection de couleurs par histogrammes pour identifier précisément les zones des mondes
"""

import cv2
import numpy as np
from PIL import Image
import json
import argparse
from pathlib import Path
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from collections import Counter

class DetecteurZonesCarte:
    def __init__(self, chemin_image):
        self.chemin_image = Path(chemin_image)
        self.image = None
        self.image_hsv = None
        self.zones_detectees = {}
        self.couleurs_mondes = {
            'grange': {'nom': 'Le monde de la grange', 'couleur_cible': [34, 139, 34]},  # Vert forêt
            'sphinx': {'nom': 'Le monde orange des Sphinx', 'couleur_cible': [255, 140, 0]},  # Orange foncé
            'linge': {'nom': 'Le monde du linge', 'couleur_cible': [138, 43, 226]},  # Violet
            'verger': {'nom': 'Le monde du verger', 'couleur_cible': [255, 192, 203]},  # Rose
            'jeux': {'nom': 'Le monde des jeux', 'couleur_cible': [0, 100, 200]},  # Bleu
            'assemblee': {'nom': 'Le monde de l\'assemblée', 'couleur_cible': [139, 69, 19]},  # Marron/rouge
            'damier': {'nom': 'Le monde du damier', 'couleur_cible': [135, 206, 235]},  # Bleu clair
            'karibu': {'nom': 'Le monde Karibu', 'couleur_cible': [255, 165, 0]},  # Orange vif
            'zob': {'nom': 'Le monde du Zob', 'couleur_cible': [128, 128, 128]},  # Gris
            'reves': {'nom': 'Le monde des rêves', 'couleur_cible': [147, 112, 219]},  # Violet clair
            'elysee': {'nom': 'Le monde Elysée', 'couleur_cible': [255, 255, 255]}  # Blanc
        }
        
    def charger_image(self):
        """Charge l'image et la convertit en différents espaces colorimétriques"""
        try:
            self.image = cv2.imread(str(self.chemin_image))
            if self.image is None:
                raise ValueError(f"Impossible de charger l'image : {self.chemin_image}")
            
            # Convertir BGR vers RGB pour matplotlib
            self.image_rgb = cv2.cvtColor(self.image, cv2.COLOR_BGR2RGB)
            # Convertir vers HSV pour une meilleure détection de couleurs
            self.image_hsv = cv2.cvtColor(self.image, cv2.COLOR_BGR2HSV)
            
            print(f"✅ Image chargée : {self.image.shape[1]}x{self.image.shape[0]} pixels")
            return True
            
        except Exception as e:
            print(f"❌ Erreur lors du chargement de l'image : {e}")
            return False
    
    def analyser_couleurs_dominantes(self, nb_couleurs=15):
        """Analyse les couleurs dominantes de l'image"""
        # Redimensionner l'image pour accélérer le traitement
        image_reduite = cv2.resize(self.image_rgb, (200, 200))
        pixels = image_reduite.reshape(-1, 3)
        
        # Utiliser K-means pour trouver les couleurs dominantes
        kmeans = KMeans(n_clusters=nb_couleurs, random_state=42, n_init=10)
        kmeans.fit(pixels)
        
        couleurs = kmeans.cluster_centers_.astype(int)
        labels = kmeans.labels_
        
        # Compter la fréquence de chaque couleur
        compteur = Counter(labels)
        couleurs_triees = []
        
        for i in range(nb_couleurs):
            pourcentage = (compteur[i] / len(labels)) * 100
            couleurs_triees.append({
                'couleur': couleurs[i].tolist(),
                'pourcentage': pourcentage,
                'hex': '#{:02x}{:02x}{:02x}'.format(*couleurs[i])
            })
        
        # Trier par pourcentage décroissant
        couleurs_triees.sort(key=lambda x: x['pourcentage'], reverse=True)
        
        print("\n🎨 Couleurs dominantes détectées :")
        for i, couleur in enumerate(couleurs_triees[:10]):
            print(f"  {i+1}. RGB{couleur['couleur']} ({couleur['hex']}) - {couleur['pourcentage']:.1f}%")
        
        return couleurs_triees
    
    def detecter_zone_couleur(self, couleur_cible, tolerance=30, taille_min=1000):
        """Détecte une zone spécifique basée sur une couleur cible"""
        # Convertir la couleur cible en HSV
        couleur_bgr = np.uint8([[couleur_cible[::-1]]])  # RGB vers BGR
        couleur_hsv = cv2.cvtColor(couleur_bgr, cv2.COLOR_BGR2HSV)[0][0]
        
        # Définir les plages de couleurs en HSV (plus robuste)
        # Assurer que les valeurs sont dans les bonnes plages et du bon type
        h_min = max(0, int(couleur_hsv[0]) - tolerance//2)
        h_max = min(179, int(couleur_hsv[0]) + tolerance//2)
        s_min = max(0, int(couleur_hsv[1]) - tolerance)
        s_max = min(255, int(couleur_hsv[1]) + tolerance)
        v_min = max(0, int(couleur_hsv[2]) - tolerance)
        v_max = min(255, int(couleur_hsv[2]) + tolerance)
        
        lower_hsv = np.array([h_min, s_min, v_min], dtype=np.uint8)
        upper_hsv = np.array([h_max, s_max, v_max], dtype=np.uint8)
        
        # Créer le masque
        masque = cv2.inRange(self.image_hsv, lower_hsv, upper_hsv)
        
        # Nettoyer le masque avec des opérations morphologiques
        kernel = np.ones((3,3), np.uint8)
        masque = cv2.morphologyEx(masque, cv2.MORPH_CLOSE, kernel)
        masque = cv2.morphologyEx(masque, cv2.MORPH_OPEN, kernel)
        
        # Trouver les contours
        contours, _ = cv2.findContours(masque, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        zones_trouvees = []
        for contour in contours:
            aire = cv2.contourArea(contour)
            if aire > taille_min:
                # Calculer le rectangle englobant
                x, y, w, h = cv2.boundingRect(contour)
                
                # Calculer le centre et le rayon pour les formes circulaires
                moments = cv2.moments(contour)
                if moments['m00'] != 0:
                    cx = int(moments['m10'] / moments['m00'])
                    cy = int(moments['m01'] / moments['m00'])
                else:
                    cx, cy = x + w//2, y + h//2
                
                # Estimer si c'est plutôt circulaire ou rectangulaire
                perimetre = cv2.arcLength(contour, True)
                circularite = 4 * np.pi * aire / (perimetre * perimetre) if perimetre > 0 else 0
                
                zone = {
                    'contour': contour,
                    'aire': aire,
                    'rectangle': (x, y, x+w, y+h),
                    'centre': (cx, cy),
                    'rayon': int(np.sqrt(aire / np.pi)),
                    'circularite': circularite,
                    'forme': 'circle' if circularite > 0.7 else 'rect'
                }
                zones_trouvees.append(zone)
        
        return zones_trouvees, masque
    
    def detecter_toutes_zones(self):
        """Détecte toutes les zones des mondes"""
        print("\n🔍 Détection des zones des mondes...")
        
        for monde_id, monde_info in self.couleurs_mondes.items():
            print(f"\n  Recherche de {monde_info['nom']}...")
            
            try:
                zones, masque = self.detecter_zone_couleur(
                    monde_info['couleur_cible'],
                    tolerance=50,
                    taille_min=500
                )
            except Exception as e:
                print(f"    ❌ Erreur lors de la détection : {e}")
                continue
            
            if zones:
                # Prendre la plus grande zone trouvée
                zone_principale = max(zones, key=lambda z: z['aire'])
                self.zones_detectees[monde_id] = {
                    'nom': monde_info['nom'],
                    'couleur_cible': monde_info['couleur_cible'],
                    'zone': zone_principale,
                    'masque': masque
                }
                
                x1, y1, x2, y2 = zone_principale['rectangle']
                cx, cy = zone_principale['centre']
                rayon = zone_principale['rayon']
                
                print(f"    ✅ Trouvé ! Aire: {zone_principale['aire']:.0f}px²")
                print(f"       Rectangle: ({x1},{y1},{x2},{y2})")
                print(f"       Centre: ({cx},{cy}), Rayon: {rayon}")
                print(f"       Forme suggérée: {zone_principale['forme']}")
            else:
                print(f"    ❌ Non trouvé")
    
    def generer_coordonnees_html(self):
        """Génère les coordonnées HTML pour les zones cliquables"""
        print("\n📝 Génération des coordonnées HTML...")
        
        html_areas = []
        for monde_id, info in self.zones_detectees.items():
            zone = info['zone']
            nom = info['nom']
            
            if zone['forme'] == 'circle':
                cx, cy = zone['centre']
                rayon = zone['rayon']
                coords = f"{cx},{cy},{rayon}"
                html_area = f'    <area shape="circle" coords="{coords}" alt="{nom}" href="/mondes/{monde_id}/" title="{nom}">'
            else:
                x1, y1, x2, y2 = zone['rectangle']
                coords = f"{x1},{y1},{x2},{y2}"
                html_area = f'    <area shape="rect" coords="{coords}" alt="{nom}" href="/mondes/{monde_id}/" title="{nom}">'
            
            html_areas.append(html_area)
            print(f"  {monde_id}: {html_area}")
        
        return html_areas
    
    def sauvegarder_resultats(self, fichier_sortie="zones-detectees.json"):
        """Sauvegarde les résultats en JSON"""
        resultats = {}
        for monde_id, info in self.zones_detectees.items():
            zone = info['zone']
            resultats[monde_id] = {
                'nom': info['nom'],
                'couleur_cible': info['couleur_cible'],
                'aire': int(zone['aire']),
                'rectangle': zone['rectangle'],
                'centre': zone['centre'],
                'rayon': int(zone['rayon']),
                'circularite': float(zone['circularite']),
                'forme': zone['forme']
            }
        
        with open(fichier_sortie, 'w', encoding='utf-8') as f:
            json.dump(resultats, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Résultats sauvegardés dans {fichier_sortie}")
    
    def visualiser_detection(self, fichier_sortie="detection-zones.png"):
        """Crée une visualisation des zones détectées"""
        fig, axes = plt.subplots(2, 2, figsize=(15, 12))
        
        # Image originale
        axes[0,0].imshow(self.image_rgb)
        axes[0,0].set_title("Image originale")
        axes[0,0].axis('off')
        
        # Image avec zones détectées
        image_avec_zones = self.image_rgb.copy()
        for monde_id, info in self.zones_detectees.items():
            zone = info['zone']
            contour = zone['contour']
            
            # Dessiner le contour
            cv2.drawContours(image_avec_zones, [contour], -1, (255, 0, 0), 3)
            
            # Dessiner le rectangle englobant
            x1, y1, x2, y2 = zone['rectangle']
            cv2.rectangle(image_avec_zones, (x1, y1), (x2, y2), (0, 255, 0), 2)
            
            # Marquer le centre
            cx, cy = zone['centre']
            cv2.circle(image_avec_zones, (cx, cy), 5, (255, 255, 0), -1)
            
            # Ajouter le nom
            cv2.putText(image_avec_zones, monde_id, (x1, y1-10), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)
        
        axes[0,1].imshow(image_avec_zones)
        axes[0,1].set_title("Zones détectées")
        axes[0,1].axis('off')
        
        # Masques combinés
        masque_combine = np.zeros(self.image_hsv.shape[:2], dtype=np.uint8)
        for info in self.zones_detectees.values():
            masque_combine = cv2.bitwise_or(masque_combine, info['masque'])
        
        axes[1,0].imshow(masque_combine, cmap='gray')
        axes[1,0].set_title("Masques des zones")
        axes[1,0].axis('off')
        
        # Statistiques
        axes[1,1].axis('off')
        stats_text = "Zones détectées:\n\n"
        for monde_id, info in self.zones_detectees.items():
            zone = info['zone']
            stats_text += f"{monde_id}:\n"
            stats_text += f"  Aire: {zone['aire']:.0f}px²\n"
            stats_text += f"  Centre: {zone['centre']}\n"
            stats_text += f"  Forme: {zone['forme']}\n\n"
        
        axes[1,1].text(0.1, 0.9, stats_text, transform=axes[1,1].transAxes, 
                      fontsize=10, verticalalignment='top', fontfamily='monospace')
        
        plt.tight_layout()
        plt.savefig(fichier_sortie, dpi=150, bbox_inches='tight')
        print(f"📊 Visualisation sauvegardée dans {fichier_sortie}")
        
        return fig

def main():
    parser = argparse.ArgumentParser(description="Détecteur de zones colorées pour la carte de Malvinaland")
    parser.add_argument("image", help="Chemin vers l'image de la carte")
    parser.add_argument("--sortie", "-o", default="zones-detectees", 
                       help="Préfixe pour les fichiers de sortie")
    parser.add_argument("--visualiser", "-v", action="store_true",
                       help="Créer une visualisation des résultats")
    
    args = parser.parse_args()
    
    # Créer le détecteur
    detecteur = DetecteurZonesCarte(args.image)
    
    # Charger l'image
    if not detecteur.charger_image():
        return 1
    
    # Analyser les couleurs dominantes
    couleurs_dominantes = detecteur.analyser_couleurs_dominantes()
    
    # Détecter toutes les zones
    detecteur.detecter_toutes_zones()
    
    # Générer les coordonnées HTML
    html_areas = detecteur.generer_coordonnees_html()
    
    # Sauvegarder les résultats
    detecteur.sauvegarder_resultats(f"{args.sortie}.json")
    
    # Sauvegarder le HTML
    with open(f"{args.sortie}.html", 'w', encoding='utf-8') as f:
        f.write("<!-- Zones cliquables générées automatiquement -->\n")
        f.write("<map name=\"carte-map\">\n")
        for area in html_areas:
            f.write(f"  {area}\n")
        f.write("</map>\n")
    
    print(f"\n💾 Code HTML sauvegardé dans {args.sortie}.html")
    
    # Créer la visualisation si demandée
    if args.visualiser:
        detecteur.visualiser_detection(f"{args.sortie}.png")
    
    print(f"\n✅ Détection terminée ! {len(detecteur.zones_detectees)} zones trouvées.")
    return 0

if __name__ == "__main__":
    exit(main())