document.addEventListener('DOMContentLoaded', () => {
    // Navbar scroll effect
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // Reveal animations on scroll
    const revealElements = document.querySelectorAll('.reveal');
    const revealOnScroll = () => {
        const triggerBottom = window.innerHeight * 0.85;

        revealElements.forEach(el => {
            const elTop = el.getBoundingClientRect().top;
            if (elTop < triggerBottom) {
                el.classList.add('visible');
            }
        });
    };

    window.addEventListener('scroll', revealOnScroll);
    revealOnScroll(); // Initial check

    // Add staggered delay to feature cards
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach((card, index) => {
        card.style.transitionDelay = `${index * 0.1}s`;
    });

    // Animate stats numbers
    const stats = document.querySelectorAll('.stat-num');
    const animateStats = () => {
        stats.forEach(stat => {
            const target = parseInt(stat.innerText.replace('k+', '')) * (stat.innerText.includes('k+') ? 1000 : 1);
            let count = 0;
            const duration = 2000;
            const increment = target / (duration / 16);

            const updateCount = () => {
                count += increment;
                if (count < target) {
                    stat.innerText = Math.floor(count) + (stat.innerText.includes('k+') ? 'k+' : '+');
                    requestAnimationFrame(updateCount);
                } else {
                    stat.innerText = target / (stat.innerText.includes('k+') ? 1000 : 1) + (stat.innerText.includes('k+') ? 'k+' : '+');
                }
            };
            updateCount();
        });
    };

    // Trigger stats animation when hero is visible
    setTimeout(animateStats, 500);
});
