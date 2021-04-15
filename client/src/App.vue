<template>
  <router-view/>
</template>
<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class App extends Vue {}
</script>
<style lang="scss">
@import 'styles/main';
</style>
