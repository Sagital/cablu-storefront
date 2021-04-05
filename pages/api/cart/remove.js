import { convertCheckoutCart } from '../../../saleor/converters'
import { deleteCheckoutLine } from '../../../saleor/api/checkout'

export default async function handler(req, res) {
  const { lineId, id } = req.body

  const checkout = await deleteCheckoutLine(id, lineId)
  const { cart, itemsInCart } = convertCheckoutCart(checkout)

  return res.json({ cart, itemsInCart })
}

export const config = {
  api: {
    bodyParser: true,
  },
}
