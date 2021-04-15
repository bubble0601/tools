<template>
  <v-app>
    <app-bar title="ミルダムアーカイブダウンローダー"/>
    <v-main>
      <div class="wrapper pl-md-10 px-1">
        <div class="input-wrapper">
          <v-text-field
            v-model="url"
            label="アーカイブURL"
            prepend-icon="link"
            placeholder="https://www.mildom.com/playback/00000000/00000000-xxxxxxxxxxxxxxxxxxxxx"
            :error-messages="status === 'fetchError' ? ['無効なURLです'] : []"
            clearable
          />
          <v-btn class="ml-4" @click="getInfo">
            情報取得
          </v-btn>
        </div>

        <template v-if="status === 'none' || status === 'fetchError'"/>
        <v-card v-else-if="status === 'fetchingInfo'" loading min-height="200px"/>
        <template v-else>
          <v-alert v-if="status === 'downloadError'" type="error">
            ダウンロード失敗
          </v-alert>
          <v-card>
            <v-row no-gutters>
              <v-col cols="12" md="3">
                <v-sheet elevation="1">
                  <v-img :src="thumnail" max-width="100%" contain/>
                </v-sheet>
              </v-col>
              <v-col>
                <v-card-title>{{ title }}</v-card-title>
                <v-card-subtitle>{{ author }}</v-card-subtitle>
              </v-col>
            </v-row>
            <v-card-text>
              <v-text-field v-model="filename" label="ファイル名" suffix=".mp4"/>
              <v-select v-model="definition" label="画質" :items="definitions" item-text="name" return-object/>

              <div class="subtitle-1">時間範囲</div>
              <v-range-slider v-model="range" :min="0" :max="rangeMax" thumb-label thumb-size="40">
                <template #thumb-label="{ value }">
                  {{ formatTime(Math.floor(length * value / rangeMax)) }}
                </template>
              </v-range-slider>

              <div class="d-flex align-center pr-4">
                <span class="subtitle-1">動画時間</span>
                <span class="ml-auto">
                  {{ formatTime(length) }}
                </span>
              </div>
              <div class="d-flex align-center mt-4 pr-4">
                <span class="subtitle-1">サイズ(予想)</span>
                <span class="ml-auto">
                  {{ estimatedSize }}
                </span>
              </div>
            </v-card-text>
            <v-card-actions class="justify-end">
              <span v-if="status === 'downloading'" class="subtitle-1 text--secondary mr-4">
                お待ち下さい(所要時間見込み:約{{ Math.floor(length / 1200) }}分)...
              </span>
              <v-btn color="primary" :loading="status === 'downloading'" :disabled="status === 'downloading'" @click="download">
                ダウンロード
              </v-btn>
            </v-card-actions>
          </v-card>
        </template>

        <div class="mt-4"/>

        <v-card class="mt-auto mb-8">
          <v-card-title>
            注意事項
          </v-card-title>
          <v-card-text>
            <p>・このツールを利用することにより生じた損害について、作者は一切の責任を負わないものとします。</p>
            <p>・サイズや所要時間は目安であり、内容や環境によっては大きな誤差がある場合がございます</p>
          </v-card-text>
        </v-card>
      </div>
    </v-main>
    <the-footer/>
  </v-app>
</template>
<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';
import axios from 'axios';
import AppBar from '@/components/AppBar.vue';
import TheFooter from '@/components/Footer.vue';

type Status = 'none' | 'fetchingInfo' | 'fetchedInfo' | 'downloading' | 'completed' | 'fetchError' | 'downloadError';

interface Definition {
  name: string;
  level: number;
  url: string;
}

@Component({
  metaInfo: {
    title: 'ミルダムアーカイブダウンローダー',
  },
  components: {
    AppBar,
    TheFooter,
  },
})
export default class Mildownload extends Vue {
  private status: Status = 'none';
  private url = '';

  private videoId = '';
  private title = '';
  private author = '';
  private thumnail = '';
  private length = 0;
  private definitions: Definition[] = [];

  private filename = '';
  private rangeMax = 1000;
  private range = [0, this.rangeMax];
  private tickLabels: (number | string)[] = [];
  private definition: Definition | null = null;

  get estimatedSize() {
    if (!this.definition) return '不明';
    const size = Math.floor(this.length * (this.range[1] - this.range[0]) / this.rangeMax * this.definition.level / 1080 / 2);
    if (size < 1000) return `約${Math.floor(size / 100) * 100}MB`;
    return `約${Math.floor(size / 1000)}GB`;
  }

  private formatTime(time: number) {
    const h = Math.floor(time / 3600);
    const m = Math.floor((time - 3600 * h) / 60);
    const s = time % 60;
    const H = h > 0 ? `${h}:` : '';
    const M = m < 10 ? `0${m}` : String(m);
    const S = s < 10 ? `0${s}` : String(s);
    return `${H}${M}:${S}`;
  }

  private getInfo() {
    this.status = 'fetchingInfo';
    axios.get('/api/mildownload/fetchinfo', {
      params: {
        url: this.url,
      },
    }).then((res) => {
      this.status = 'fetchedInfo';
      this.videoId = res.data.v_id;
      this.title = res.data.title;
      this.author = res.data.author_info.login_name;
      this.thumnail = res.data.video_pic;
      this.length = Math.floor(res.data.video_length / 1000);
      this.definitions = res.data.video_link;

      this.filename = `${this.title} - ${this.author}`;
      this.definition = this.definitions[this.definitions.length - 1];
      this.tickLabels[1] = '0:00';
      this.tickLabels[100] = this.length;
    }).catch(() => {
      this.status = 'fetchError';
    });
  }

  private download() {
    if (!this.definition) return;
    this.status = 'downloading';
    axios.get('/api/mildownload/download', {
      params: {
        vid: this.videoId,
        m3u8: this.definition.url,
        start: this.range[0] === 0 ? -1 : Math.floor(this.length * this.range[0] / this.rangeMax),
        end: this.range[1] === 1000 ? -1 : Math.floor(this.length * this.range[1] / this.rangeMax),
      },
      responseType: 'blob',
    }).then((res) => {
      this.status = 'completed';
      this.execDownload(res.data);
    }).catch(() => {
      this.status = 'downloadError';
    });
  }

  private execDownload(blob: string) {
    const url = URL.createObjectURL(new Blob([blob], { type: 'video/mp4' }));
    const linkEl = document.createElement('a');
    linkEl.href = url;
    linkEl.setAttribute('download', this.filename);
    document.body.appendChild(linkEl);
    linkEl.click();
    URL.revokeObjectURL(url);
    linkEl.parentNode?.removeChild(linkEl);
  }
}
</script>
<style lang="scss" scoped>
.wrapper {
  display: flex;
  flex-direction: column;
  max-width: 860px;
  height: 100%;
}
.input-wrapper {
  display: flex;
  align-items: center;
}
</style>
