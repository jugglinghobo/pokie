var te = document.querySelector('textarea[autosize]');
resizeTextarea(te);
te.addEventListener('keyup', function() {
  resizeTextarea(this);
});

function resizeTextarea(textarea) {
  textarea.style.height = '24px';
  textarea.style.height = textarea.scrollHeight + 12 + 'px';
}
