<template>
  <ul class="header-dropdown__items">
    <li class="header-dropdown__item" v-bind:class="[notification.read ? '' : 'unread']" @click="push(notification)" v-for="notification in notifications">
      <div class="header-dropdown__container">
        <div class="header-dropdown__unread-icon" v-bind:class="[notification.read ? 'is-read' : '']"></div>
        <div class="header-dropdown__text-holder">
          <p class="header-dropdown__text">
            {{ notification.message }}
          </p>
          <time class="header-dropdown__time-holder">
            {{ notification.created_at }}前
          </time>
        </div>
      </div>
    </li>
  </ul>
</template>

<script>
  import axios from "axios"

  const meta = document.querySelector('meta[name="csrf-token"]');
  axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : meta ? meta.getAttribute('content') : ''
  };

  export default {
    data() {
      return {
        notifications: null,
        isRead: false
      }
    },
    mounted() {
      axios.get(`/api/notifications.json`)
        .then(response => {
          return response.data
        })
        .then(json => {
          this.notifications = json
        })
        .catch(error => {
          console.warn('Failed to parsing.')
        })
    },
    methods: {
      push(notification) {
        if (notification.read) return;
        axios.patch(`/api/notifications/${notification.id}`, {
          id: notification.id,
          read: true,
        })
        .then(response => {
          notification.read = true
        })
        .then(response => {
          if (this.isAllChecked(this.notifications)) {
            const i = document.querySelector('.header-notification__badge')
            i.classList.remove('header-notification__badge')
          }
        })
        .catch(error => {
          console.warn("Failed to parsing.")
        })
      },
      isAllChecked(notifications) {
        return notifications.every((notification) => {
          return notification.read
        })
      }
    },
  }
</script>

<style scoped>

</style>
