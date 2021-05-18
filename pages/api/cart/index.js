import { readCartTokenCookie } from '../../../saleor/cookies'
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
    const { cart } = checkout
    page.cart = cart
  }

  res.json(page)
}
