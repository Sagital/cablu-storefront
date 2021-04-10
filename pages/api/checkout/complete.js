import { checkoutComplete, checkoutPaymentCreate } from '../../../saleor/api/checkout'
import { deleteCartTokenCookie } from '../../../saleor/cookies'

export default async function handler(req, res) {
  let { checkoutId, paymentMethodId, totalPrice } = req.body

  try {
    await checkoutPaymentCreate(checkoutId, paymentMethodId, totalPrice)

    const order = await checkoutComplete(checkoutId)

    deleteCartTokenCookie(res)

    res.status(200).json({
      order,
    })
  } catch (e) {
    console.log(JSON.stringify(e))
    res.status(500).json({ message: 'Internal Server Error' })
  }
}
