<template>
  <v-footer app absolute class="justify-space-between">
    <span class="caption" :class="textColorClass">
      © 2021 ibubble.net
    </span>
    <router-link class="subtitle-2 text-decoration-none text--primary" to="/contact">
      お問い合わせなど
    </router-link>
  </v-footer>
</template>
<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class Footer extends Vue {
  get textColorClass() {
    return this.$vuetify.theme.dark ? 'grey--text text--lighten-1' : 'grey--text text--darken-1';
  }
}
</script>
