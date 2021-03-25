export default async function(req, res) {
  const result = {
    pageData: {
      title: 'React Storefront',
      slots: {
        heading: 'Welcome to your new React Storefront app.',
        description:
          '\n' +
          '                <p>\n' +
          "                Here you'll find mock home, category, subcategory, product, and cart pages that you can\n" +
          '                use as a starting point to build your PWA.\n' +
          '              </p>\n' +
          '              <p>Happy coding!</p>\n' +
          '            ',
      },
    },
    appData: {
      menu: { items: [], header: 'header', footer: 'footer' },
      tabs: [
        {
          as: '/s/cabluri-audio',
          href: '/s/[...categorySlug]',
          text: 'Cabluri Audio',
        },
        {
          as: '/s/conectica-audio',
          href: '/s/[...categorySlug]',
          text: 'Conectica Audio',
        },
        {
          as: '/s/cabluri-video-multimedia',
          href: '/s/[...categorySlug]',
          text: 'Cabluri Video Multimedia',
        },
      ],
    },
  }

  res.json(result)
}
