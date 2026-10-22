(() => {
  const blocks = document.querySelectorAll('.quiz-block');
  const isEnglish = document.documentElement.lang.toLowerCase().startsWith('en');
  const correctLabel = isEnglish ? 'correct' : 'correta';
  const incorrectLabel = isEnglish ? 'incorrect' : 'incorreta';

  blocks.forEach(block => {
    const answer = block.querySelector('.quiz-ans');
    const explanation = block.querySelector('.quiz-exp');
    if (!answer || !explanation) return;

    const answerLetter = (answer.textContent.match(/(?:Resposta|Answer):\s*([A-E])/i) || [])[1];
    if (!answerLetter) return;

    answer.hidden = true;
    explanation.hidden = true;
    explanation.setAttribute('role', 'status');
    explanation.setAttribute('aria-live', 'polite');

    block.querySelectorAll('.quiz-opt').forEach(option => {
      option.type = 'button';
      option.addEventListener('click', () => {
        if (block.dataset.answered) return;
        block.dataset.answered = '1';

        const optionLetter = (option.textContent.match(/^\s*([A-E])\)/) || [])[1];
        const correct = optionLetter === answerLetter;
        option.classList.add(correct ? 'quiz-correct' : 'quiz-wrong');
        option.setAttribute('aria-label', `${option.textContent.trim()} — ${correct ? correctLabel : incorrectLabel}`);

        if (!correct) {
          block.querySelectorAll('.quiz-opt').forEach(candidate => {
            const candidateLetter = (candidate.textContent.match(/^\s*([A-E])\)/) || [])[1];
            if (candidateLetter === answerLetter) {
              candidate.classList.add('quiz-correct');
              candidate.setAttribute('aria-label', `${candidate.textContent.trim()} — ${correctLabel}`);
            }
          });
        }

        explanation.hidden = false;
        const scrollBehavior = window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth';
        explanation.scrollIntoView({ behavior: scrollBehavior, block: 'nearest' });
      });
    });
  });
})();
