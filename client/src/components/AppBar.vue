<template>
  <v-app-bar app absolute dense flat>
    <v-toolbar-title>
      {{ title }}
    </v-toolbar-title>
    <v-spacer/>
    <theme-toggler/>
  </v-app-bar>
</template>
<script lang="ts">
import { Vue, Component, Prop } from 'vue-property-decorator';
import ThemeToggler from '@/components/ThemeToggler.vue';

@Component({
  components: {
    ThemeToggler,
  },
})
export default class AppBar extends Vue {
  @Prop({ type: String, required: true })
  private title!: string;
}
</script>
