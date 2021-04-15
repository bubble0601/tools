module.exports = {
  outputDir: '../static',
  productionSourceMap: process.env.NODE_ENV !== 'production',

  configureWebpack: {
    devtool: 'source-map',
  },

  devServer: {
    proxy: process.env.API_BASE_URL || 'http://localhost:9292',
  },

  transpileDependencies: [
    'vuetify',
  ],
  css: {
    loaderOptions: {
      scss: {
        additionalData: "@import '@/styles/variables.scss';",
      },
    },
  },
};
