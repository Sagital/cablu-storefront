import { checkoutComplete, checkoutPaymentCreate } from '../../../saleor/api/checkout'
import { deleteCartTokenCookie } from '../../../saleor/cookies'

export default async function handler(req, res) {
  console.log('in checkout update')

  let { checkoutId, paymentMethodId, totalPrice } = req.body

  try {
    await checkoutPaymentCreate(checkoutId, paymentMethodId, totalPrice)

    console.log('aaaa')

    const order = await checkoutComplete(checkoutId)

    console.log(order)

    deleteCartTokenCookie(res)

    res.status(200).json({
      order,
    })
  } catch (e) {
    console.log(JSON.stringify(e))
    res.status(500).json({ message: 'Internal Server Error' })
  }
}
