<template>
  <v-app>
    <app-bar title="Tools"/>
    <v-main>
      <v-container>
        <v-row>
          <v-col v-for="item in items" :key="item.to" cols="3" md="4" xs="6">
            <v-card :to="item.to">
              <v-card-title>
                {{ item.name }}
              </v-card-title>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
    <the-footer/>
  </v-app>
</template>
<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import AppBar from '@/components/AppBar.vue';
import TheFooter from '@/components/Footer.vue';

@Component({
  metaInfo: {
    title: 'Tools',
  },
  components: {
    AppBar,
    TheFooter,
  },
})
export default class Home extends Vue {
  private items = [
    { name: 'ミルダムアーカイブダウンローダー', to: '/mildownload' },
  ];
}
</script>
