<template>
  <div class="header-dropdown__item" v-bind:class="[isRead ? '' : 'unread']" @click="push">
    <div class="header-dropdown__text-holder">
      <p class="header-dropdown__text">
        「{{ serviceName }}」が更新されました！次回の更新日は{{ renewedOn }}です。
      </p>
      <time class="header-dropdown__time-holder">
        {{ createdAt }}前
      </time>
    </div>
    <div class="header-dropdown__unread-icon" v-bind:class="[isRead ? 'is-read' : '']"></div>
  </div>
</template>

<script>
  import axios from "axios"

  const meta = document.querySelector('meta[name="csrf-token"]');
  axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : meta ? meta.getAttribute('content') : ''
  };

  export default {
    props: ["serviceName", "renewedOn", "createdAt", "notificationId"],
    data() {
      return {
        isRead: false
      }
    },
    mounted() {
      axios.get(`/api/notifications/${this.notificationId}.json`)
      .then(response => {
        return response.data.read
      })
      .then(read => {
        this.isRead = read
      })
      .catch(error => {
        console.warn('Failed to parsing.')
      })
    },
    methods: {
      push() {
        if (this.isRead) return;
        axios.patch(`/api/notifications/${this.notificationId}`, {
          id: this.notificationId,
          read: true,
        })
        .then(response => {
          this.isRead = true
        })
        .catch(error => {
          console.warn("Failed to parsing.")
        })
      }
    },
  }
</script>

<style scoped>

</style>
