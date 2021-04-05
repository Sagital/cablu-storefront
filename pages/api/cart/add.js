import { addCheckoutLine, createCheckout } from '../../../saleor/api/checkout'
import { convertCheckoutCart } from '../../../saleor/converters'
const CART_TOKEN_COOKIE = 'cart_token'

async function handler(req, res) {
  const cartToken = req.cookies[CART_TOKEN_COOKIE]

  const { product, quantity, id } = req.body

  let checkout

  if (!cartToken) {
    checkout = await createCheckout(product.id, quantity)

    res.setHeader(
      'Set-Cookie',
      ''.concat(CART_TOKEN_COOKIE, '=').concat(checkout.token, '; Path=/')
    )
  } else {
    checkout = await addCheckoutLine(id, product.id, quantity)
  }

  const { cart, itemsInCart } = convertCheckoutCart(checkout)

  res.json({
    cart,
    itemsInCart,
  })
}

export const config = {
  api: {
    bodyParser: true,
  },
}

export default handler
