import { ApolloClient, gql, InMemoryCache } from '@apollo/client'
import categoryQuery from './queries'

export default async function plp(req, res) {
  // Note: the structure of the query string is controlled by the queryForState prop passed
  // to SearchResultsProvider in pages/s/[...categorySlug].js.
  const { categorySlug: slug } = req.query

  const client = new ApolloClient({
    uri: 'https://api.cablu.io/graphql/',
    cache: new InMemoryCache(),
  })

  const variables = {
    // dunno why this comes as an array
    slug: slug[0],
  }

  const result = await client.query({
    query: gql`
      ${categoryQuery}
    `,
    variables,
  })

  const x = {
    pageData: {
      id: ['1'],
      name: 'Subcategory 1',
      title: 'Subcategory 1',
      total: 100,
      page: 0,
      totalPages: 5,
      filters: [],
      sortOptions: [
        {
          name: 'Price - Lowest',
          code: 'price_asc',
        },
        {
          name: 'Price - Highest',
          code: 'price_desc',
        },
        {
          name: 'Most Popular',
          code: 'pop',
        },
        {
          name: 'Highest Rated',
          code: 'rating',
        },
      ],
      facets: [
        {
          name: 'Color',
          ui: 'buttons',
          options: [
            {
              name: 'Red',
              code: 'color:red',
              image: {
                src: 'https://dummyimage.com/48x48/f44336?text=%20',
                alt: 'red',
              },
            },
            {
              name: 'Green',
              code: 'color:green',
              image: {
                src: 'https://dummyimage.com/48x48/4caf50?text=%20',
                alt: 'green',
              },
            },
            {
              name: 'Blue',
              code: 'color:blue',
              image: {
                src: 'https://dummyimage.com/48x48/2196f3?text=%20',
                alt: 'blue',
              },
            },
            {
              name: 'Grey',
              code: 'color:grey',
              image: {
                src: 'https://dummyimage.com/48x48/e0e0e0?text=%20',
                alt: 'grey',
              },
            },
            {
              name: 'Teal',
              code: 'color:teal',
              image: {
                src: 'https://dummyimage.com/48x48/009688?text=%20',
                alt: 'teal',
              },
            },
            {
              name: 'Orange',
              code: 'color:orange',
              image: {
                src: 'https://dummyimage.com/48x48/ff9800?text=%20',
                alt: 'orange',
              },
            },
            {
              name: 'Purple',
              code: 'color:purple',
              image: {
                src: 'https://dummyimage.com/48x48/9c27b0?text=%20',
                alt: 'purple',
              },
            },
            {
              name: 'Black',
              code: 'color:black',
              image: {
                src: 'https://dummyimage.com/48x48/424242?text=%20',
                alt: 'black',
              },
            },
          ],
        },
        {
          name: 'Size',
          ui: 'buttons',
          options: [
            {
              name: 'SM',
              code: 'size:sm',
            },
            {
              name: 'MD',
              code: 'size:md',
            },
            {
              name: 'LG',
              code: 'size:lg',
            },
            {
              name: 'XL',
              code: 'size:xl',
            },
            {
              name: 'XXL',
              code: 'size:xxl',
            },
          ],
        },
        {
          name: 'Type',
          ui: 'checkboxes',
          options: [
            {
              name: 'New',
              code: 'type:new',
              matches: 100,
            },
            {
              name: 'Used',
              code: 'type:used',
              matches: 20,
            },
          ],
        },
      ],
      products: [
        {
          id: '1',
          url: '/p/1',
          name: 'Product 1',
          price: 10.99,
          priceText: '$10.99',
          rating: 4.5,
          thumbnail: {
            src: 'https://dummyimage.com/400x400/4caf50/ffffff?text=Product%201',
            alt: 'Product 1',
          },
          media: {
            full: [
              {
                src: 'https://dummyimage.com/600x600/4caf50/ffffff?text=Product%201',
                alt: 'Product 1',
                magnify: {
                  height: 1200,
                  width: 1200,
                  src: 'https://dummyimage.com/1200x1200/4caf50/ffffff?text=Product%201',
                },
              },
              {
                src: 'https://dummyimage.com/600x400/f44336/ffffff?text=Product%201',
                alt: 'Product 1',
                magnify: {
                  height: 800,
                  width: 1200,
                  src: 'https://dummyimage.com/1200x800/f44336/ffffff?text=Product%201',
                },
              },
              {
                src: 'https://dummyimage.com/400x600/2196f3/ffffff?text=Product%201',
                alt: 'Product 1',
                magnify: {
                  height: 1200,
                  width: 800,
                  src: 'https://dummyimage.com/800x1200/2196f3/ffffff?text=Product%201',
                },
              },
            ],
            thumbnails: [
              {
                src: 'https://dummyimage.com/300x300/4caf50/ffffff?text=Product%201',
                alt: 'Product 1',
              },
              {
                src: 'https://dummyimage.com/300x233/f44336/ffffff?text=Product%201',
                alt: 'Product 1',
              },
              {
                src: 'https://dummyimage.com/233x300/2196f3/ffffff?text=Product%201',
                alt: 'Product 1',
              },
            ],
          },
          description:
            'Excepteur adipisicing ullamco magna eiusmod ea adipisicing exercitation. Magna aute nulla ut pariatur quis voluptate. Lorem veniam ea et sunt. Magna anim minim excepteur excepteur culpa nulla sint nisi aliquip do aliqua laborum mollit irure. Dolor Lorem dolor minim consequat reprehenderit non reprehenderit nulla minim sunt. Anim proident et cupidatat laborum enim anim incididunt officia sit nostrud incididunt. Ullamco sunt eu enim et sint reprehenderit qui. Pariatur irure et tempor ea. Aliquip non dolore aliquip reprehenderit commodo velit commodo. Nostrud aliquip pariatur labore eu do cillum deserunt elit ea dolor pariatur.',
          specs:
            'Dolor fugiat aliquip incididunt ut elit. Laboris ad fugiat fugiat ea duis mollit labore do reprehenderit irure proident. Pariatur nulla et Lorem Lorem amet enim exercitation fugiat qui tempor consequat dolor pariatur ea. Incididunt deserunt commodo consequat exercitation occaecat ut nostrud officia tempor consequat dolor culpa magna. Dolore eu non enim excepteur labore fugiat esse sunt aute. Magna exercitation consectetur enim cupidatat amet officia minim eiusmod nulla. Nostrud ad voluptate proident excepteur consectetur. Ad exercitation sint sunt non eu ex quis adipisicing sunt. Est eiusmod exercitation minim aliquip proident dolor. Nisi ad irure voluptate occaecat.',
        },
      ],
      breadcrumbs: [
        {
          text: 'Home',
          href: '/',
        },
      ],
    },
    appData: {
      menu: {
        items: [
          {
            text: 'Category 1',
            items: [
              {
                text: 'Subcategory 1',
                href: '/s/[...categorySlug]',
                as: '/s/1',
                expanded: true,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
              {
                text: 'Subcategory 2',
                href: '/s/[...categorySlug]',
                as: '/s/2',
                expanded: false,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
              {
                text: 'Subcategory 3',
                href: '/s/[...categorySlug]',
                as: '/s/3',
                expanded: false,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
              {
                text: 'Subcategory 4',
                href: '/s/[...categorySlug]',
                as: '/s/4',
                expanded: false,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
              {
                text: 'Subcategory 5',
                href: '/s/[...categorySlug]',
                as: '/s/5',
                expanded: false,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
            ],
          },
          {
            text: 'Category 2',
            items: [
              {
                text: 'Subcategory 1',
                href: '/s/[...categorySlug]',
                as: '/s/1',
                expanded: true,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
              {
                text: 'Subcategory 2',
                href: '/s/[...categorySlug]',
                as: '/s/2',
                expanded: false,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
              {
                text: 'Subcategory 3',
                href: '/s/[...categorySlug]',
                as: '/s/3',
                expanded: false,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
              {
                text: 'Subcategory 4',
                href: '/s/[...categorySlug]',
                as: '/s/4',
                expanded: false,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
              {
                text: 'Subcategory 5',
                href: '/s/[...categorySlug]',
                as: '/s/5',
                expanded: false,
                items: [
                  {
                    text: 'Product 1',
                    href: '/p/[productId]',
                    as: '/p/1',
                  },
                  {
                    text: 'Product 2',
                    href: '/p/[productId]',
                    as: '/p/2',
                  },
                  {
                    text: 'Product 3',
                    href: '/p/[productId]',
                    as: '/p/3',
                  },
                  {
                    text: 'Product 4',
                    href: '/p/[productId]',
                    as: '/p/4',
                  },
                  {
                    text: 'Product 5',
                    href: '/p/[productId]',
                    as: '/p/5',
                  },
                ],
              },
            ],
          },
        ],
        header: 'header',
        footer: 'footer',
      },
      tabs: [
        {
          as: '/s/1',
          href: '/s/[...categorySlug]',
          text: 'Category 1',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/2',
          href: '/s/[...categorySlug]',
          text: 'Category 2',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/3',
          href: '/s/[...categorySlug]',
          text: 'Category 3',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/4',
          href: '/s/[...categorySlug]',
          text: 'Category 4',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/5',
          href: '/s/[...categorySlug]',
          text: 'Category 5',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/6',
          href: '/s/[...categorySlug]',
          text: 'Category 6',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/7',
          href: '/s/[...categorySlug]',
          text: 'Category 7',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/8',
          href: '/s/[...categorySlug]',
          text: 'Category 8',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/9',
          href: '/s/[...categorySlug]',
          text: 'Category 9',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
        {
          as: '/s/10',
          href: '/s/[...categorySlug]',
          text: 'Category 10',
          items: [
            {
              as: '/s/1',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 1',
            },
            {
              as: '/s/2',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 2',
            },
            {
              as: '/s/3',
              href: '/s/[...categorySlug]',
              text: 'Subcategory 3',
            },
          ],
        },
      ],
    },
  }

  const category = result.data.category

  x.pageData.id = [category.id]
  x.pageData.name = category.name
  x.pageData.title = category.title

  x.pageData.products = category.products.edges
    .map(edge => edge.node)
    .filter(p => p.defaultVariant !== null)
    .map(convertProduct)

  res.json(x)
}

const convertProduct = product => {
  if (!product.defaultVariant) {
    console.log('could not find default variant of product')
    console.log(product)
  }

  return {
    id: product.defaultVariant.id,
    url: '/p/' + product.defaultVariant.id,
    name: product.defaultVariant.name,
    price: 10.99, // the price as a number
    priceText: '$10.99', // the price as formatted text with currency
    description: 'product description', // the product description
    specs: 'product specs', // the product specs - this is just a suggestion.  Feel free to add any additional fields needed for the UI.
    thumbnail: {
      src: product.thumbnail.url, // the thumbnail URL
      alt: product.thumbnail.alt, // alt text for the thumbnail
    },
    media: {
      // images and videos for the MediaCarousel component
      full: [
        {
          // an array of full size images
          src: product.images[0].url, // the URL of the full size image
          alt: product.images[0].url.alt, // alt text for the full size image
          type: 'image', // "image" or "video" - by default entries will be treated as images
          // magnify: {
          //   // optional - provides a high-res image for manigfication on hover in desktop browsers
          //   height: 1200, // the height of the high-res image
          //   width: 1200, // the width of the high-res image
          //   src: 'https://domain.com/path/to/image', // the URL of the high res image
          // },
        },
      ],
      thumbnails: [
        {
          // an array of thumbnails to display below the main image carousel
          src: product.thumbnail.url, // the thumbnail URL
          alt: product.thumbnail.alt, // alt text for the thumbnail
        },
      ],
    },
    sizes: [
      {
        // an array of available sizes
        id: 'sm', // the size code
        text: 'SM', // text to display on the button corresponding to this size
      },
    ],
  }
}
