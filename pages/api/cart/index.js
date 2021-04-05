import { readCartTokenCookie } from '../../../saleor/cookies'
import { convertCheckoutCart } from '../../../saleor/converters'
import { getCheckout } from '../../../saleor/api/checkout'

export default async function(req, res) {
  const page = {
    title: 'HAI DINAMo',
    breadcrumbs: [
      {
        text: 'Home',
        href: '/',
      },
    ],
    cart: {
      items: [],
    },
  }

  const token = readCartTokenCookie(req)
  const checkout = await getCheckout(token)

  if (checkout) {
    const { cart, itemsInCart } = convertCheckoutCart(checkout)
    page.cart = cart
    page.itemsInCart = itemsInCart
  }

  res.json(page)
}
