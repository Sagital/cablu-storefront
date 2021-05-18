import { addCheckoutLine, createCheckout } from '../../../saleor/api/checkout'

const CART_TOKEN_COOKIE = 'cart_token'

async function handler(req, res, next) {
  const cartToken = req.cookies[CART_TOKEN_COOKIE]

  const { product, quantity, id } = req.body

  let checkout

  try {
    if (!cartToken) {
      checkout = await createCheckout(product.id, quantity)
      res.setHeader(
        'Set-Cookie',
        ''.concat(CART_TOKEN_COOKIE, '=').concat(checkout.token, '; Path=/')
      )
    } else {
      checkout = await addCheckoutLine(id, product.id, quantity)
    }

    res.json({
      checkout,
    })
  } catch (e) {
    res.status(422).json({ error: e.message })
  }
}

export const config = {
  api: {
    bodyParser: true,
  },
}

export default handler
