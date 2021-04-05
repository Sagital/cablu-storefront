export const convertProduct = product => {
  return {
    id: product.id,
    url: '/p/' + product.id,
    name: product.name,
    price: 10.99, // the price as a number
    priceText: '$10.99', // the price as formatted text with currency
    description: 'product description', // the product description
    specs: 'product specs', // the product specs - this is just a suggestion.  Feel free to add any additional fields needed for the UI.
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
    colors: [
      {
        // an array of available colors
        text: 'Red', // optional - text to display below the color button
        id: 'red', // the color code
        image: {
          // the image for the color swatch
          src: 'https://domain.com/path/to/image', // the URL for the color swatch
          alt: 'red', // alt text for the color swatch
        },
        media: {
          // overrides the `media` on the base `product` object when this color is selected
          full: [
            {
              // this is how you can change images and thumbnails when the user selects a different color
              src: 'https://domain.com/path/to/image',
              alt: 'Product 1',
              type: 'image',
              magnify: {
                height: 1200,
                width: 1200,
                src: 'https://domain.com/path/to/image',
              },
            },
          ],
          thumbnails: [
            {
              src: 'https://domain.com/path/to/image',
              alt: 'green',
            },
          ],
        },
      },
    ],
  }
}

export const convertCheckoutLine = ({ id, quantity, variant }) => {
  return {
    lineId: id,
    id: variant.id,
    name: variant.product.name,
    thumbnail: { src: variant.product.thumbnail.url },
    quantity,
  }
}

const convertCheckoutAddressToAddress = checkoutAddress => {
  return {
    firstName: checkoutAddress.firstName,
    lastName: checkoutAddress.lastName,
    phone: checkoutAddress.phone.replace(/^\+4/, ''),
    region: checkoutAddress.countryArea,
    locality: checkoutAddress.city,
    streetAddress: checkoutAddress.streetAddress1,
  }
}

export const convertCheckoutCart = checkout => {
  const cart = {
    id: checkout.id,
    items: checkout.lines.map(line => convertCheckoutLine(line)),
  }
  const itemsInCart = cart.items.reduce((total, item) => {
    return total + item.quantity
  }, 0)

  return { cart, itemsInCart }
}

export const convertShippingPrice = checkoutShippingPrice => {
  return {
    net: checkoutShippingPrice.net.amount,
    gross: checkoutShippingPrice.gross.amount,
  }
}

export const convertTotalPrice = checkoutTotalPrice => {
  return {
    net: checkoutTotalPrice.net.amount,
    gross: checkoutTotalPrice.gross.amount,
  }
}

export const convertCheckout = checkout => {
  const cart = {
    id: checkout.id,
    items: checkout.lines.map(line => convertCheckoutLine(line)),
  }
  const itemsInCart = cart.items.reduce((total, item) => {
    return total + item.quantity
  }, 0)

  let shippingAddress = null

  if (checkout.shippingAddress) {
    shippingAddress = convertCheckoutAddressToAddress(checkout.shippingAddress)
  }

  let email = null

  // we use dummy@example.com as a placeholder for email address
  if (checkout.email && checkout.email !== 'dummy@example.com') {
    email = checkout.email
  }

  let billingAddress = null

  if (checkout.billingAddress) {
    billingAddress = convertCheckoutAddressToAddress(checkout.billingAddress)
  }

  return { cart, itemsInCart, shippingAddress, billingAddress, email }
}
