// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'bootstrap'
import '@fortawesome/fontawesome-free/js/all'
require("jquery")
require("@nathanvda/cocoon")

// 画像
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

// JavaScript
import '../javascripts/image_upload_form.js'
import '../javascripts/slick.js'

// CSS
import '../stylesheets/application.scss'

Rails.start()
Turbolinks.start()
ActiveStorage.start()
