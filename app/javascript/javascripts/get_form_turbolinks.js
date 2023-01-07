document.addEventListener('turbolinks:load', function(event){
  const forms = document.querySelectorAll('form[method=get][data-remote=true]')
  for (const form of forms) {
    form.addEventListener('ajax:beforeSend', function(event) {
      const options = event.detail[1]

      Tubolinks.visit(options.url)
      event.preventDefault()
    })
  }
})
