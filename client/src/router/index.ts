import Vue from 'vue';
import VueRouter, { RouteConfig } from 'vue-router';

Vue.use(VueRouter);

const routes: Array<RouteConfig> = [
  {
    path: '/',
    name: 'Home',
    component: () => import(/* webpackChunkName: "home" */ '@/views/Home.vue'),
  },
  {
    path: '/mildownload',
    name: 'Mildownload',
    component: () => import(/* webpackChunkName: "tools" */ '@/views/Mildownload.vue'),
  },
  {
    path: '/contact',
    name: 'Contact',
    component: () => import(/* webpackChunkName: "contact" */ '@/views/Contact.vue'),
  },
];

const router = new VueRouter({
  mode: 'history',
  routes,
});

export default router;
