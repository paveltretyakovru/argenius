/*
 *   Copyright (c) 2023 Pavel Tretyakov
 *   All rights reserved.
 */

ready(function() {
  let current = 0;

  const sections = [
    document.querySelector('#home'),
    document.querySelector('#usage'),
  ];

  window.onscroll = function(e) {
    const scrollUp = this.oldScroll > this.scrollY;
    this.oldScroll = this.scrollY;
    e.preventDefault();

    scroll(scrollUp);
  }

  function scroll(up) {
    let next;
    
    // If scrolling bottom
    if (!up) {
      if (sections[current + 1]) {
        next = sections[current + 1];
        current += 1;
      } else {
        next = sections[current];
      }
    } else {
      if (sections[current - 1]) {
        next = sections[current - 1];
        current -= 1;
      } else {
        next = sections[current];
      }
    }

    if (next) {
      window.scrollTo({ top: next.offsetTop, behavior: 'smooth' })
    }
  }

  parseCodeLineNumbers();
});

function ready(fn) {
  if (document.readyState !== 'loading') {
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
}

function parseCodeLineNumbers() {
  const $blocks = document.querySelectorAll('pre');

  $blocks.forEach($block => {
    $block.innerHTML = $block.innerHTML.replace(/^(.*)$/mg, "<span class=\"line\">$1</span>");
  });
}