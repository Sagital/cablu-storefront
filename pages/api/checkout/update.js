import { validateAddress } from '../../../components/checkout/addressValidator'
import {
  checkoutBillingAddressUpdate,
  checkoutEmailUpdate,
  checkoutShippingAddressUpdate,
  checkoutShippingMethodUpdate,
} from '../../../saleor/api/checkout'

export default async function handler(req, res) {
  console.log('in checkout update')

  let { shippingAddress, billingAddress, checkoutId, shippingMethodId, email } = req.body

  const shippingAddressErrors = validateAddress(shippingAddress)
  const billingAddressErrors = validateAddress(billingAddress)

  // we collect the guest email in the shippingAddress
  if (!email) {
    shippingAddressErrors.email = 'Required'
  }

  if (Object.keys(shippingAddressErrors).length || Object.keys(billingAddressErrors).length) {
    res.status(400).json({ error: { billingAddressErrors, shippingAddressErrors } })
  } else {
    try {
      let shippingAddressUpdate = await checkoutShippingAddressUpdate(checkoutId, shippingAddress)
      // let shippingMethodUpdate = await checkoutShippingMethodUpdate(checkoutId, shippingMethodId)
      // let billingAddressUpdate =
      // let emailUpdate = await checkoutEmailUpdate(checkoutId, email)

      let [emailUpdate, billingAddressUpdate, shippingMethodUpdate] = await Promise.all([
        checkoutEmailUpdate(checkoutId, email),
        checkoutBillingAddressUpdate(checkoutId, billingAddress),
        checkoutShippingMethodUpdate(checkoutId, shippingMethodId),
      ])

      // TODO error handling if checkout errors

      const shippingPrice = {
        net: shippingMethodUpdate.shippingPrice.net.amount,
        gross: shippingMethodUpdate.shippingPrice.gross.amount,
      }

      const totalPrice = {
        net: shippingMethodUpdate.totalPrice.net.amount,
        gross: shippingMethodUpdate.totalPrice.gross.amount,
      }

      // ideally we would like to take them from the server but at the moment it takes too long
      res.status(200).json({
        shippingAddress,
        email,
        billingAddress,
        shippingMethodId,
        shippingPrice,
        totalPrice,
      })
    } catch (e) {
      console.log(JSON.stringify(e))
      res.status(500).json({ message: 'Internal Server Error' })
    }

    //let checkout = await checkoutEmailUpdate(checkoutId, shippingAddress.email)
    //let checkout = await checkoutShippingAddressUpdate(checkoutId, shippingAddress)
  }
}
