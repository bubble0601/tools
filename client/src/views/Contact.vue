<template>
  <v-app>
    <app-bar title="お問い合わせなど"/>
    <v-main>
      <v-container>
        <v-card>
          <v-card-text>
            <v-alert type="info">
              お問い合わせ・ご質問などありましたらこちらへ
            </v-alert>
            <v-form>
              <v-text-field v-model="name" label="お名前(任意)" filled dense/>
              <v-text-field v-model="email" type="email" label="メールアドレス(任意)" filled dense/>
              <v-textarea v-model="content" label="内容" auto-grow filled :error-messages="errors"/>
            </v-form>
          </v-card-text>
          <v-card-actions class="justify-end">
            <v-btn color="primary" @click="submit">送信</v-btn>
          </v-card-actions>
        </v-card>
        <v-card class="mt-8">
          <v-card-title>
            注意事項
          </v-card-title>
          <v-card-text>
            <p>・提供いただいた個人情報はお問い合わせ対応のため以外に利用することはございません。</p>
            <p>・お問い合わせに対応できない場合もございます。</p>
          </v-card-text>
        </v-card>
      </v-container>
    </v-main>
    <v-snackbar v-model="snackbar" app right :color="snackbarColor || 'primary'">
      {{ snackbarMessage }}
    </v-snackbar>
    <the-footer/>
  </v-app>
</template>
<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import axios from 'axios';
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
  private name = '';
  private email = '';
  private content = '';
  private errors = [] as string[];

  private snackbar = false;
  private snackbarColor = '';
  private snackbarMessage = '';

  @Watch('content')
  private onContentChanged() {
    if (this.errors.length && this.content) {
      this.errors = [];
    }
  }

  private submit() {
    if (!this.content) {
      this.errors.push('内容を入力してください');
      return;
    }
    axios.post('/api/contact', {
      name: this.name,
      email: this.email,
      content: this.content,
    }).then(() => {
      this.showSnackbar('success', '送信成功');
    }).catch(() => {
      this.showSnackbar('error', '送信失敗');
    });
  }

  private showSnackbar(color: string, message: string) {
    this.snackbar = true;
    this.snackbarColor = color;
    this.snackbarMessage = message;
  }
}
</script>
