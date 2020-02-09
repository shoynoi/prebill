import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue'
import Notification from '../notification.vue'

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const notifications = document.querySelectorAll('.js-notification');
  if (notifications) {
    for (let i = 0; i < notifications.length; i++) {
      let notification = notifications[i];

      const serviceName = notification.getAttribute('data-service-name');
      const renewedOn = notification.getAttribute('data-renewed_on');
      const createdAt = notification.getAttribute('data-created_at');
      const notificationId = notification.getAttribute('data-notification-id');
      new Vue({
        render: h => h(Notification, { props: { serviceName: serviceName, renewedOn: renewedOn, createdAt: createdAt, notificationId: notificationId } })
      }).$mount('.js-notification')
    }
  }
})
