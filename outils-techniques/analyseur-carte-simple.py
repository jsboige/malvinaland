#!/usr/bin/env python3
"""
Analyseur simple de la carte de Malvinaland
Analyse les couleurs dominantes et génère des zones approximatives
"""

import cv2
import numpy as np
from PIL import Image
import json
import sys
from pathlib import Path

def analyser_carte(chemin_image):
    """Analyse simple de la carte pour identifier les zones colorées"""
    
    print(f"📖 Chargement de l'image : {chemin_image}")
    
    # Charger l'image
    try:
        image = cv2.imread(chemin_image)
        if image is None:
            print(f"❌ Impossible de charger l'image : {chemin_image}")
            return None
        
        height, width = image.shape[:2]
        print(f"✅ Image chargée : {width}x{height} pixels")
        
    except Exception as e:
        print(f"❌ Erreur lors du chargement : {e}")
        return None
    
    # Convertir en RGB pour l'analyse
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    
    # Définir les zones approximatives basées sur l'analyse visuelle de la carte
    # Ces coordonnées sont des estimations basées sur la structure typique de la carte
    zones_approximatives = {
        'grange': {
            'nom': 'Le monde de la grange',
            'coords': (120, 480, 280, 580),  # Rectangle vert en haut à gauche
            'forme': 'rect',
            'couleur_attendue': [34, 139, 34]
        },
        'sphinx': {
            'nom': 'Le monde orange des Sphinx', 
            'coords': (465, 440, 80),  # Cercle orange au centre-haut
            'forme': 'circle',
            'couleur_attendue': [255, 140, 0]
        },
        'linge': {
            'nom': 'Le monde du linge',
            'coords': (615, 320, 775, 420),  # Rectangle violet en haut à droite
            'forme': 'rect',
            'couleur_attendue': [138, 43, 226]
        },
        'verger': {
            'nom': 'Le monde du verger',
            'coords': (710, 570, 870, 670),  # Rectangle rose en bas à droite
            'forme': 'rect',
            'couleur_attendue': [255, 192, 203]
        },
        'jeux': {
            'nom': 'Le monde des jeux',
            'coords': (15, 100, 175, 200),  # Rectangle bleu en bas à gauche
            'forme': 'rect',
            'couleur_attendue': [0, 100, 200]
        },
        'assemblee': {
            'nom': 'Le monde de l\'assemblée',
            'coords': (275, 135, 435, 235),  # Rectangle rouge/marron au centre-bas
            'forme': 'rect',
            'couleur_attendue': [139, 69, 19]
        },
        'damier': {
            'nom': 'Le monde du damier',
            'coords': (650, 100, 810, 200),  # Rectangle bleu clair en haut centre
            'forme': 'rect',
            'couleur_attendue': [135, 206, 235]
        },
        'karibu': {
            'nom': 'Le monde Karibu',
            'coords': (465, 190, 625, 290),  # Rectangle orange au centre-bas
            'forme': 'rect',
            'couleur_attendue': [255, 165, 0]
        },
        'zob': {
            'nom': 'Le monde du Zob',
            'coords': (715, 150, 875, 250),  # Rectangle gris en bas à droite
            'forme': 'rect',
            'couleur_attendue': [128, 128, 128]
        },
        'reves': {
            'nom': 'Le monde des rêves',
            'coords': (300, 250, 400, 350),  # Rectangle violet
            'forme': 'rect',
            'couleur_attendue': [147, 112, 219]
        },
        'elysee': {
            'nom': 'Le monde Elysée',
            'coords': (150, 350, 250, 450),  # Rectangle blanc
            'forme': 'rect',
            'couleur_attendue': [255, 255, 255]
        }
    }
    
    # Analyser chaque zone pour vérifier la présence de couleurs
    zones_validees = {}
    
    print("\n🔍 Analyse des zones...")
    
    for monde_id, zone_info in zones_approximatives.items():
        print(f"  Analyse de {zone_info['nom']}...")
        
        try:
            # Extraire la région d'intérêt
            if zone_info['forme'] == 'rect':
                x1, y1, x2, y2 = zone_info['coords']
                # Ajuster les coordonnées si elles dépassent l'image
                x1 = max(0, min(x1, width-1))
                y1 = max(0, min(y1, height-1))
                x2 = max(x1+1, min(x2, width))
                y2 = max(y1+1, min(y2, height))
                
                roi = image_rgb[y1:y2, x1:x2]
                
            elif zone_info['forme'] == 'circle':
                cx, cy, r = zone_info['coords']
                # Créer un masque circulaire
                x1, y1 = max(0, cx-r), max(0, cy-r)
                x2, y2 = min(width, cx+r), min(height, cy+r)
                
                if x2 > x1 and y2 > y1:
                    roi = image_rgb[y1:y2, x1:x2]
                else:
                    print(f"    ⚠️ Zone circulaire hors limites")
                    continue
            
            if roi.size > 0:
                # Calculer la couleur moyenne de la région
                couleur_moyenne = np.mean(roi.reshape(-1, 3), axis=0)
                
                # Calculer la variance pour voir si la zone est homogène
                variance = np.var(roi.reshape(-1, 3), axis=0)
                variance_totale = np.sum(variance)
                
                zones_validees[monde_id] = {
                    'nom': zone_info['nom'],
                    'coords': zone_info['coords'],
                    'forme': zone_info['forme'],
                    'couleur_moyenne': couleur_moyenne.tolist(),
                    'couleur_attendue': zone_info['couleur_attendue'],
                    'variance': variance_totale,
                    'taille_roi': roi.shape
                }
                
                print(f"    ✅ Zone analysée - Couleur moyenne: {couleur_moyenne.astype(int)}")
                
            else:
                print(f"    ❌ ROI vide")
                
        except Exception as e:
            print(f"    ❌ Erreur lors de l'analyse : {e}")
    
    return zones_validees, (width, height)

def generer_html(zones_validees, fichier_sortie="zones-corrigees.html"):
    """Génère le code HTML pour les zones cliquables"""
    
    print(f"\n📝 Génération du code HTML...")
    
    html_lines = ["<!-- Zones cliquables générées automatiquement -->"]
    html_lines.append('<map name="carte-map">')
    
    for monde_id, zone in zones_validees.items():
        if zone['forme'] == 'rect':
            x1, y1, x2, y2 = zone['coords']
            coords = f"{x1},{y1},{x2},{y2}"
            shape = "rect"
        elif zone['forme'] == 'circle':
            cx, cy, r = zone['coords']
            coords = f"{cx},{cy},{r}"
            shape = "circle"
        
        html_line = f'  <area shape="{shape}" coords="{coords}" alt="{zone["nom"]}" href="/mondes/{monde_id}/" title="{zone["nom"]}">'
        html_lines.append(html_line)
        print(f"  {monde_id}: {html_line}")
    
    html_lines.append('</map>')
    
    # Sauvegarder le fichier HTML
    with open(fichier_sortie, 'w', encoding='utf-8') as f:
        f.write('\n'.join(html_lines))
    
    print(f"\n💾 Code HTML sauvegardé dans {fichier_sortie}")
    return html_lines

def main():
    if len(sys.argv) < 2:
        print("Usage: python analyseur-carte-simple.py <chemin_image>")
        return 1
    
    chemin_image = sys.argv[1]
    
    if not Path(chemin_image).exists():
        print(f"❌ Fichier non trouvé : {chemin_image}")
        return 1
    
    # Analyser la carte
    resultat = analyser_carte(chemin_image)
    
    if resultat is None:
        return 1
    
    zones_validees, dimensions = resultat
    
    print(f"\n📊 Résultats de l'analyse:")
    print(f"  Dimensions de l'image: {dimensions[0]}x{dimensions[1]}")
    print(f"  Zones analysées: {len(zones_validees)}")
    
    # Générer le HTML
    html_lines = generer_html(zones_validees)
    
    # Sauvegarder les données JSON
    with open("zones-analysees.json", 'w', encoding='utf-8') as f:
        json.dump(zones_validees, f, indent=2, ensure_ascii=False)
    
    print(f"💾 Données JSON sauvegardées dans zones-analysees.json")
    
    print(f"\n✅ Analyse terminée avec succès !")
    return 0

if __name__ == "__main__":
    exit(main())