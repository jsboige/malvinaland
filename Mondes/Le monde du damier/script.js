/**
 * Script pour le Monde du Damier
 * Implémente les fonctionnalités interactives pour les énigmes
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le Monde du Damier!');
    
    // Initialisation des composants
    initDamierRepresentation();
    initBatailleNavale();
    initEchiquier();
    
    // Gestion de la navigation fluide
    setupSmoothScrolling();
});

/**
 * Initialise la représentation visuelle du damier dans la section ambiance
 */
function initDamierRepresentation() {
    const damierGrid = document.querySelector('.damier-grid');
    if (!damierGrid) return;
    
    // Création d'une représentation simplifiée du damier 48x20
    for (let row = 0; row < 20; row++) {
        for (let col = 0; col < 48; col++) {
            const cell = document.createElement('div');
            cell.classList.add('damier-cell');
            
            // Alternance de couleurs pour créer l'effet damier
            if ((row + col) % 2 === 0) {
                cell.style.backgroundColor = '#1a5f9e'; // Bleu solaire
            } else {
                cell.style.backgroundColor = '#0a3b6d'; // Bleu foncé
            }
            
            // Effet de brillance aléatoire pour simuler la réflexion du soleil
            if (Math.random() < 0.1) {
                cell.style.backgroundColor = '#4d8bc9'; // Bleu clair
                cell.style.boxShadow = 'inset 0 0 5px rgba(255, 255, 255, 0.8)';
            }
            
            damierGrid.appendChild(cell);
        }
    }
    
    // Animation subtile pour simuler la lumière du soleil
    setInterval(() => {
        const randomCells = damierGrid.querySelectorAll('.damier-cell');
        const randomCell = randomCells[Math.floor(Math.random() * randomCells.length)];
        
        if (randomCell) {
            randomCell.style.transition = 'background-color 1s';
            randomCell.style.backgroundColor = '#ffd700'; // Couleur soleil
            
            setTimeout(() => {
                randomCell.style.backgroundColor = '';
                randomCell.style.transition = '';
            }, 1000);
        }
    }, 2000);
}

/**
 * Initialise la grille de bataille navale pour l'énigme 1
 */
function initBatailleNavale() {
    const batailleGrid = document.getElementById('bataille-grid');
    if (!batailleGrid) return;
    
    // Création de la grille 48x20
    for (let row = 0; row < 20; row++) {
        for (let col = 0; col < 48; col++) {
            const cell = document.createElement('div');
            cell.classList.add('bataille-cell');
            cell.dataset.row = row + 1;
            cell.dataset.col = col + 1;
            
            // Alternance de couleurs pour créer l'effet damier
            if ((row + col) % 2 === 0) {
                cell.style.backgroundColor = '#1a5f9e'; // Bleu solaire
            } else {
                cell.style.backgroundColor = '#0a3b6d'; // Bleu foncé
            }
            
            // Ajout des coordonnées au survol
            cell.addEventListener('mouseover', () => {
                showCoordinates(cell, col + 1, row + 1);
            });
            
            cell.addEventListener('mouseout', () => {
                hideCoordinates();
            });
            
            // Ajout d'un événement de clic pour "tirer" sur la grille
            cell.addEventListener('click', () => {
                checkBatailleNavaleHit(cell, col + 1, row + 1);
            });
            
            batailleGrid.appendChild(cell);
        }
    }
    
    // Création d'un élément pour afficher les coordonnées
    const coordDisplay = document.createElement('div');
    coordDisplay.id = 'coord-display';
    coordDisplay.style.position = 'absolute';
    coordDisplay.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
    coordDisplay.style.color = 'white';
    coordDisplay.style.padding = '5px';
    coordDisplay.style.borderRadius = '3px';
    coordDisplay.style.fontSize = '12px';
    coordDisplay.style.pointerEvents = 'none';
    coordDisplay.style.display = 'none';
    coordDisplay.style.zIndex = '100';
    document.body.appendChild(coordDisplay);
}

/**
 * Affiche les coordonnées au survol d'une cellule
 */
function showCoordinates(cell, col, row) {
    const coordDisplay = document.getElementById('coord-display');
    if (!coordDisplay) return;
    
    coordDisplay.textContent = `(${col}, ${row})`;
    coordDisplay.style.display = 'block';
    
    // Positionne l'affichage des coordonnées près du curseur
    document.addEventListener('mousemove', updateCoordPosition);
}

/**
 * Met à jour la position de l'affichage des coordonnées
 */
function updateCoordPosition(e) {
    const coordDisplay = document.getElementById('coord-display');
    if (!coordDisplay) return;
    
    coordDisplay.style.left = `${e.pageX + 10}px`;
    coordDisplay.style.top = `${e.pageY + 10}px`;
}

/**
 * Cache l'affichage des coordonnées
 */
function hideCoordinates() {
    const coordDisplay = document.getElementById('coord-display');
    if (!coordDisplay) return;
    
    coordDisplay.style.display = 'none';
    document.removeEventListener('mousemove', updateCoordPosition);
}

/**
 * Vérifie si un tir touche un vaisseau dans la bataille navale
 */
function checkBatailleNavaleHit(cell, col, row) {
    // Définition des positions des vaisseaux selon l'énigme
    const ships = [
        // Vaisseau de 2 cases (ligne 5, colonnes 10-11)
        { positions: [{col: 10, row: 5}, {col: 11, row: 5}], letters: ['P', 'H'] },
        
        // Vaisseau vertical de 3 cases (colonne 30, lignes 7-9)
        { positions: [{col: 30, row: 7}, {col: 30, row: 8}, {col: 30, row: 9}], letters: ['O', '', ''] },
        
        // Vaisseau en angle droit (coordonnées 40,4 - 40,5 - 41,5)
        { positions: [{col: 40, row: 4}, {col: 40, row: 5}, {col: 41, row: 5}], letters: ['O', '', ''] },
        
        // Vaisseau horizontal de 4 cases (ligne 10, colonnes 22-25)
        { positions: [{col: 22, row: 10}, {col: 23, row: 10}, {col: 24, row: 10}, {col: 25, row: 10}], letters: ['', 'T', 'O', 'N'] },
        
        // Vaisseau diagonal de 5 cases
        { positions: [{col: 1, row: 16}, {col: 2, row: 17}, {col: 3, row: 18}, {col: 4, row: 19}, {col: 5, row: 20}], letters: ['', '', '', '', ''] }
    ];
    
    // Vérification si la cellule cliquée fait partie d'un vaisseau
    let hit = false;
    let letter = '';
    
    ships.forEach(ship => {
        ship.positions.forEach((pos, index) => {
            if (pos.col === col && pos.row === row) {
                hit = true;
                letter = ship.letters[index] || '';
                
                // Marquer la cellule comme touchée
                cell.style.backgroundColor = '#ff6b6b'; // Rouge pour indiquer un hit
                
                // Afficher la lettre si elle existe
                if (letter) {
                    cell.textContent = letter;
                    cell.style.color = 'white';
                    cell.style.fontWeight = 'bold';
                    cell.style.display = 'flex';
                    cell.style.justifyContent = 'center';
                    cell.style.alignItems = 'center';
                    cell.style.fontSize = '1.2rem';
                }
            }
        });
    });
    
    if (!hit) {
        // Marquer la cellule comme manquée
        cell.style.backgroundColor = '#7a8899'; // Gris pour indiquer un miss
    }
    
    // Vérifier si tous les vaisseaux ont été trouvés
    checkBatailleNavaleCompletion();
}

/**
 * Vérifie si tous les vaisseaux ont été trouvés
 */
function checkBatailleNavaleCompletion() {
    const batailleGrid = document.getElementById('bataille-grid');
    if (!batailleGrid) return;
    
    const hitCells = batailleGrid.querySelectorAll('.bataille-cell[style*="background-color: rgb(255, 107, 107)"]');
    
    // Le nombre total de cases occupées par des vaisseaux est 17
    if (hitCells.length >= 17) {
        // Collecter les lettres dans l'ordre
        const letters = Array.from(batailleGrid.querySelectorAll('.bataille-cell'))
            .filter(cell => cell.textContent)
            .sort((a, b) => {
                const aCol = parseInt(a.dataset.col);
                const aRow = parseInt(a.dataset.row);
                const bCol = parseInt(b.dataset.col);
                const bRow = parseInt(b.dataset.row);
                
                // Trier d'abord par ligne, puis par colonne
                if (aRow !== bRow) return aRow - bRow;
                return aCol - bCol;
            })
            .map(cell => cell.textContent)
            .join('');
        
        if (letters === 'PHOTON') {
            // Afficher un message de félicitations
            const enigmeCard = document.getElementById('enigme-bataille');
            if (enigmeCard) {
                const successMessage = document.createElement('div');
                successMessage.classList.add('enigme-success');
                successMessage.innerHTML = '<h4>🎉 Félicitations !</h4><p>Vous avez découvert le mot-clé : <strong>PHOTON</strong>, l\'essence même de la lumière !</p>';
                successMessage.style.backgroundColor = 'rgba(76, 175, 80, 0.1)';
                successMessage.style.borderLeft = '4px solid #4caf50';
                successMessage.style.padding = '1rem';
                successMessage.style.marginTop = '1rem';
                
                enigmeCard.appendChild(successMessage);
            }
        }
    }
}

/**
 * Initialise l'échiquier pour l'énigme 2
 */
function initEchiquier() {
    const echiquierGrid = document.getElementById('echiquier-grid');
    if (!echiquierGrid) return;
    
    // Création de l'échiquier 8x8 (simplifié par rapport au damier 48x20)
    for (let row = 0; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            const cell = document.createElement('div');
            cell.classList.add('echiquier-cell');
            cell.dataset.row = row + 1;
            cell.dataset.col = col + 1;
            
            // Alternance de couleurs pour créer l'effet damier
            if ((row + col) % 2 === 0) {
                cell.style.backgroundColor = '#d1d8e0'; // Gris clair
            } else {
                cell.style.backgroundColor = '#7a8899'; // Gris foncé
            }
            
            echiquierGrid.appendChild(cell);
        }
    }
    
    // Placement initial des pièces selon l'énigme
    const pieces = [
        { type: 'roi', color: 'blanc', position: { col: 4, row: 5 } },
        { type: 'tour', color: 'noir', position: { col: 4, row: 3 } },
        { type: 'tour', color: 'noir', position: { col: 6, row: 5 } },
        { type: 'fou', color: 'noir', position: { col: 2, row: 3 } },
        { type: 'fou', color: 'noir', position: { col: 6, row: 7 } },
        { type: 'cavalier', color: 'noir', position: { col: 2, row: 6 } }
    ];
    
    // Placement des pièces sur l'échiquier
    pieces.forEach(piece => {
        placePiece(echiquierGrid, piece);
    });
    
    // Ajout des événements pour déplacer le roi
    setupRoiMovement(echiquierGrid);
}

/**
 * Place une pièce sur l'échiquier
 */
function placePiece(grid, piece) {
    const cell = grid.querySelector(`.echiquier-cell[data-row="${piece.position.row}"][data-col="${piece.position.col}"]`);
    if (!cell) return;
    
    // Création de l'élément de pièce
    const pieceElement = document.createElement('div');
    pieceElement.classList.add('piece', piece.type, piece.color);
    pieceElement.dataset.type = piece.type;
    pieceElement.dataset.color = piece.color;
    
    // Symboles Unicode pour les pièces d'échecs
    const symbols = {
        roi: { blanc: '♔', noir: '♚' },
        dame: { blanc: '♕', noir: '♛' },
        tour: { blanc: '♖', noir: '♜' },
        fou: { blanc: '♗', noir: '♝' },
        cavalier: { blanc: '♘', noir: '♞' },
        pion: { blanc: '♙', noir: '♟' }
    };
    
    pieceElement.textContent = symbols[piece.type][piece.color];
    pieceElement.style.fontSize = '2rem';
    pieceElement.style.display = 'flex';
    pieceElement.style.justifyContent = 'center';
    pieceElement.style.alignItems = 'center';
    pieceElement.style.width = '100%';
    pieceElement.style.height = '100%';
    pieceElement.style.cursor = piece.type === 'roi' && piece.color === 'blanc' ? 'pointer' : 'default';
    
    cell.appendChild(pieceElement);
}

/**
 * Configure les mouvements du roi blanc
 */
function setupRoiMovement(grid) {
    const cells = grid.querySelectorAll('.echiquier-cell');
    
    cells.forEach(cell => {
        cell.addEventListener('click', () => {
            const roi = grid.querySelector('.piece.roi.blanc');
            if (!roi) return;
            
            const roiCell = roi.parentElement;
            const targetRow = parseInt(cell.dataset.row);
            const targetCol = parseInt(cell.dataset.col);
            const currentRow = parseInt(roiCell.dataset.row);
            const currentCol = parseInt(roiCell.dataset.col);
            
            // Vérifier si le mouvement est valide pour un roi (1 case dans n'importe quelle direction)
            const rowDiff = Math.abs(targetRow - currentRow);
            const colDiff = Math.abs(targetCol - currentCol);
            
            if ((rowDiff <= 1 && colDiff <= 1) && (rowDiff > 0 || colDiff > 0)) {
                // Vérifier si la case cible est vide
                if (!cell.querySelector('.piece')) {
                    // Vérifier si le roi ne sera pas en échec après le mouvement
                    if (!isKingInCheck(grid, targetRow, targetCol)) {
                        // Déplacer le roi
                        moveRoi(roi, cell);
                        
                        // Vérifier si le roi a atteint une case avec une lettre
                        checkLetterReveal(cell);
                        
                        // Vérifier si la séquence de mouvements est complète
                        checkEchiquierCompletion();
                    } else {
                        // Indiquer que le mouvement mettrait le roi en échec
                        cell.style.backgroundColor = 'rgba(255, 0, 0, 0.3)';
                        setTimeout(() => {
                            cell.style.backgroundColor = '';
                        }, 500);
                    }
                }
            }
        });
    });
}

/**
 * Vérifie si le roi serait en échec à la position donnée
 */
function isKingInCheck(grid, kingRow, kingCol) {
    // Vérifier les menaces des tours
    const tours = grid.querySelectorAll('.piece.tour.noir');
    for (const tour of tours) {
        const tourCell = tour.parentElement;
        const tourRow = parseInt(tourCell.dataset.row);
        const tourCol = parseInt(tourCell.dataset.col);
        
        // Une tour menace si elle est sur la même ligne ou colonne
        if (tourRow === kingRow || tourCol === kingCol) {
            return true;
        }
    }
    
    // Vérifier les menaces des fous
    const fous = grid.querySelectorAll('.piece.fou.noir');
    for (const fou of fous) {
        const fouCell = fou.parentElement;
        const fouRow = parseInt(fouCell.dataset.row);
        const fouCol = parseInt(fouCell.dataset.col);
        
        // Un fou menace si la différence entre les lignes et les colonnes est la même (diagonale)
        if (Math.abs(fouRow - kingRow) === Math.abs(fouCol - kingCol)) {
            return true;
        }
    }
    
    // Vérifier les menaces des cavaliers
    const cavaliers = grid.querySelectorAll('.piece.cavalier.noir');
    for (const cavalier of cavaliers) {
        const cavalierCell = cavalier.parentElement;
        const cavalierRow = parseInt(cavalierCell.dataset.row);
        const cavalierCol = parseInt(cavalierCell.dataset.col);
        
        // Un cavalier menace en L (2 cases dans une direction, 1 dans l'autre)
        const rowDiff = Math.abs(cavalierRow - kingRow);
        const colDiff = Math.abs(cavalierCol - kingCol);
        
        if ((rowDiff === 2 && colDiff === 1) || (rowDiff === 1 && colDiff === 2)) {
            return true;
        }
    }
    
    return false;
}

/**
 * Déplace le roi vers une nouvelle case
 */
function moveRoi(roi, targetCell) {
    const sourceCell = roi.parentElement;
    
    // Animation de déplacement
    const sourceRect = sourceCell.getBoundingClientRect();
    const targetRect = targetCell.getBoundingClientRect();
    
    const deltaX = targetRect.left - sourceRect.left;
    const deltaY = targetRect.top - sourceRect.top;
    
    roi.style.transition = 'transform 0.5s';
    roi.style.transform = `translate(${deltaX}px, ${deltaY}px)`;
    
    // Après l'animation, déplacer réellement la pièce
    setTimeout(() => {
        roi.style.transition = '';
        roi.style.transform = '';
        targetCell.appendChild(roi);
        
        // Enregistrer le mouvement dans l'historique
        recordMove(sourceCell, targetCell);
    }, 500);
}

/**
 * Enregistre un mouvement dans l'historique
 */
function recordMove(sourceCell, targetCell) {
    // Créer l'historique s'il n'existe pas encore
    if (!window.moveHistory) {
        window.moveHistory = [];
    }
    
    // Ajouter le mouvement à l'historique
    window.moveHistory.push({
        from: {
            row: parseInt(sourceCell.dataset.row),
            col: parseInt(sourceCell.dataset.col)
        },
        to: {
            row: parseInt(targetCell.dataset.row),
            col: parseInt(targetCell.dataset.col)
        }
    });
}

/**
 * Vérifie si la case révèle une lettre
 */
function checkLetterReveal(cell) {
    const row = parseInt(cell.dataset.row);
    const col = parseInt(cell.dataset.col);
    
    // Définition des positions des lettres selon l'énigme
    const letters = [
        { position: { col: 3, row: 5 }, letter: 'F' },
        { position: { col: 2, row: 4 }, letter: 'U' },
        { position: { col: 1, row: 4 }, letter: 'S' },
        { position: { col: 1, row: 3 }, letter: 'I' },
        { position: { col: 1, row: 2 }, letter: 'O' },
        { position: { col: 1, row: 1 }, letter: 'N' }
    ];
    
    // Vérifier si la case contient une lettre
    const letterInfo = letters.find(l => l.position.row === row && l.position.col === col);
    
    if (letterInfo) {
        // Créer un élément pour afficher la lettre
        const letterElement = document.createElement('div');
        letterElement.classList.add('revealed-letter');
        letterElement.textContent = letterInfo.letter;
        letterElement.style.position = 'absolute';
        letterElement.style.top = '0';
        letterElement.style.left = '0';
        letterElement.style.width = '100%';
        letterElement.style.height = '100%';
        letterElement.style.display = 'flex';
        letterElement.style.justifyContent = 'center';
        letterElement.style.alignItems = 'center';
        letterElement.style.fontSize = '1.5rem';
        letterElement.style.fontWeight = 'bold';
        letterElement.style.color = '#1a5f9e';
        letterElement.style.backgroundColor = 'rgba(255, 215, 0, 0.3)';
        letterElement.style.zIndex = '1';
        
        cell.appendChild(letterElement);
    }
}

/**
 * Vérifie si la séquence de mouvements du roi est complète
 */
function checkEchiquierCompletion() {
    if (!window.moveHistory || window.moveHistory.length < 5) return;
    
    // Vérifier si les 5 derniers mouvements correspondent à la séquence correcte
    const lastMoves = window.moveHistory.slice(-5);
    
    // Séquence correcte selon l'énigme
    const correctSequence = [
        { from: { col: 4, row: 5 }, to: { col: 3, row: 4 } }, // F
        { from: { col: 3, row: 4 }, to: { col: 2, row: 3 } }, // U
        { from: { col: 2, row: 3 }, to: { col: 1, row: 2 } }, // S
        { from: { col: 1, row: 2 }, to: { col: 1, row: 1 } }, // I
        { from: { col: 1, row: 1 }, to: { col: 1, row: 0 } }  // O
    ];
    
    // Vérifier si la séquence est correcte
    let isCorrect = true;
    for (let i = 0; i < lastMoves.length; i++) {
        const move = lastMoves[i];
        const correct = correctSequence[i];
        
        if (move.from.col !== correct.from.col || move.from.row !== correct.from.row ||
            move.to.col !== correct.to.col || move.to.row !== correct.to.row) {
            isCorrect = false;
            break;
        }
    }
    
    if (isCorrect) {
        // Afficher un message de félicitations
        const enigmeCard = document.getElementById('enigme-echiquier');
        if (enigmeCard) {
            const successMessage = document.createElement('div');
            successMessage.classList.add('enigme-success');
            successMessage.innerHTML = '<h4>🎉 Félicitations !</h4><p>Vous avez découvert le mot-clé : <strong>FUSION</strong>, la source de l\'énergie solaire !</p>';
            successMessage.style.backgroundColor = 'rgba(76, 175, 80, 0.1)';
            successMessage.style.borderLeft = '4px solid #4caf50';
            successMessage.style.padding = '1rem';
            successMessage.style.marginTop = '1rem';
            
            enigmeCard.appendChild(successMessage);
        }
    }
}

/**
 * Configure le défilement fluide pour la navigation
 */
function setupSmoothScrolling() {
    const links = document.querySelectorAll('.monde-nav a');
    
    links.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            
            const targetId = link.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80, // Offset pour tenir compte de l'en-tête
                    behavior: 'smooth'
                });
            }
        });
    });
}