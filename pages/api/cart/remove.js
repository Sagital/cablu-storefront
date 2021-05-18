import { extractCheckoutCart } from '../../../saleor/converters'
import { deleteCheckoutLine } from '../../../saleor/api/checkout'

export default async function handler(req, res) {
  const { lineId, id } = req.body

  const checkout = await deleteCheckoutLine(id, lineId)
  const cart = extractCheckoutCart(checkout)

  return res.json({ cart })
}

export const config = {
  api: {
    bodyParser: true,
  },
}
