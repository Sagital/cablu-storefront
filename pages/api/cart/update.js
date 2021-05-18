import { updateCheckoutLine } from '../../../saleor/api/checkout'

export default async function handler(req, res) {
  const { item, quantity, id } = req.body

  try {
    const cart = await updateCheckoutLine(id, item.id, quantity)
    return res.json(cart)
  } catch (e) {
    res.status(422).json({ error: e.message })
  }
}

export const config = {
  api: {
    bodyParser: true,
  },
}
