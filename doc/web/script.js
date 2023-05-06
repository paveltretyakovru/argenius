/*
 *   Copyright (c) 2023 Pavel Tretyakov
 *   All rights reserved.
 */
var isFirefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1;

ready(function() {
  parseCodeLineNumbers();

  if (isFirefox) {
    makeFirefoxScrolling();
  }
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

function makeFirefoxScrolling() {
  let current = 0;

  const sections = [
    document.querySelector('#home'),
    document.querySelector('#usage'),
  ];

  window.onscroll = function(e) {
    const scrollUp = this.oldScroll > this.scrollY;
    this.oldScroll = this.scrollY;
    e.preventDefault();

    scrollFun(scrollUp);
  }

  function scrollFun(up) {
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
      // window.scrollTo({ top: next.offsetTop, behavior: 'smooth' })
      setTimeout(function() {
        scroll({ top: next.offsetTop, behavior: 'smooth' });
      }, 1);
      
    }
  }
}