// web/firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyAFNTNmQNEl58DBsJsdMGcgXTwwDyqd5p8',
  appId: '1:1020052408808:web:3ba865c59f60ba9cbc3c5d',
  messagingSenderId: '1020052408808',
  projectId: 'parcial-final-b5832',
  authDomain: 'parcial-final-b5832.firebaseapp.com',
  storageBucket: 'parcial-final-b5832.firebasestorage.app',
  measurementId: 'G-TVLCX85M6K',
});

const messaging = firebase.messaging();
