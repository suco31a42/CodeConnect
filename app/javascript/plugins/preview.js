document.addEventListener('turbolinks:load', () => {
  const createImageHTML = (blob) => {
    const imageElement = document.createElement('img');
    imageElement.setAttribute('class', 'new-img');
    imageElement.setAttribute('src', blob);
    return imageElement;
  };

  document.getElementById('post_post_images').addEventListener('change', (e) => {
    const fileInput = e.target;
    const imageContainer = document.getElementById('new-image');
    imageContainer.innerHTML = ''; // 以前のプレビュー画像を削除

    for (const file of fileInput.files) {
      const blob = window.URL.createObjectURL(file);
      const imageElement = createImageHTML(blob);
      imageContainer.appendChild(imageElement);
    }
  });
});
