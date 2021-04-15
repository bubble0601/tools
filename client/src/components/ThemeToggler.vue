<template>
  <v-btn small icon @click="darkTheme = !darkTheme">
    <v-icon v-text="darkTheme ? 'dark_mode' : 'light_mode'"/>
  </v-btn>
</template>
<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';
import { localStorageManager as lsm } from '@/utils/storage';

@Component
export default class ThemeToggler extends Vue {
  get darkTheme() {
    return this.$vuetify.theme.dark;
  }

  set darkTheme(val) {
    this.$vuetify.theme.dark = val;
    lsm.set('theme', val ? 'dark' : 'light');
  }

  protected created() {
    this.$vuetify.theme.dark = lsm.get('theme') === 'dark';
  }
}
</script>
