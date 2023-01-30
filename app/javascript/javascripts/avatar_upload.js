document.addEventListener('turbolinks:load', (event) => {
  const uploader = document.querySelector('.uploader');
  uploader.addEventListener('change', (e) => {
    const file = uploader.files[0];
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => {
      const image = reader.result;
      document.querySelector('.avatar').setAttribute('src', image);
    }
  });
});
