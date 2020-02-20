import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue'
import Notification from '../notification.vue'

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('js-notification')) {
    new Vue({
      render: h => h(Notification)
    }).$mount('#js-notification')
  }
})
