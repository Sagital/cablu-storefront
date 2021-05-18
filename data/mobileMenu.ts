import { IMobileMenu } from '../interfaces/menus/mobile-menu'

const dataMobileMenu: IMobileMenu = [
  {
    type: 'link',
    title: 'Home',
    url: '/',
  },

  {
    type: 'link',
    title: 'Categories',
    url: '',
    children: [
      {
        type: 'link',
        title: 'Cabluri Audio',
        url: '/s/cabluri-audio',
      },
      {
        type: 'link',
        title: 'Conectica Audio',
        url: '/s/conectica-audio',
      },
      {
        type: 'link',
        title: 'Cabluri Video Multimedia',
        url: '/s/cabluri-video-multimedia',
      },
    ],
  },

  {
    type: 'link',
    title: 'Account',
    url: '/account/login',
  },
]

export default dataMobileMenu
