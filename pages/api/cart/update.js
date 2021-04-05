import { convertCheckoutCart } from '../../../saleor/converters'
import { updateCheckoutLine } from '../../../saleor/api/checkout'

export default async function handler(req, res) {
  const { item, quantity, id } = req.body

  const checkout = await updateCheckoutLine(id, item.id, quantity)

  // TODO move this to saleor
  const { cart, itemsInCart } = convertCheckoutCart(checkout)
  return res.json({ cart, itemsInCart })
}

export const config = {
  api: {
    bodyParser: true,
  },
}
