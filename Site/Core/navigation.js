// JavaScript de base pour le site mobile-first

document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans les mondes de Malvinha!');

    // Exemple de fonctionnalité : navigation entre les sections
    const links = document.querySelectorAll('nav ul li a');
    links.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = link.getAttribute('href').substring(1);
            const targetSection = document.getElementById(targetId);
            if (targetSection) {
                window.scrollTo({
                    top: targetSection.offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
});