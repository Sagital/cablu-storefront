import {
  checkoutBillingAddressUpdate,
  checkoutComplete,
  checkoutEmailUpdate,
  checkoutShippingAddressUpdate,
  checkoutShippingMethodUpdate,
} from '../../../saleor/api/checkout'
import { deleteCartTokenCookie } from '../../../saleor/cookies'
import { validateAddress } from '../../../components/checkout/addressValidator'

export default async function handler(req, res) {
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
      await Promise.all([
        checkoutEmailUpdate(checkoutId, email),
        checkoutShippingAddressUpdate(checkoutId, shippingAddress),
        checkoutBillingAddressUpdate(checkoutId, billingAddress),
      ])


      //let shippingAddressUpdate = await checkoutShippingAddressUpdate(checkoutId, shippingAddress)
      // let shippingMethodUpdate = await checkoutShippingMethodUpdate(checkoutId, shippingMethodId)
      // let billingAddressUpdate =
      // let emailUpdate = await checkoutEmailUpdate(checkoutId, email)

      let [billingAddressUpdate, shippingMethodUpdate] = await Promise.all([
        checkoutShippingMethodUpdate(checkoutId, shippingMethodId),
      ])


      let order = await checkoutComplete(checkoutId)

      deleteCartTokenCookie(req, res)

      // ideally we would like to take them from the server but at the moment it takes too long
      res.status(200).json(order)
    } catch (e) {
      console.log(e)
      console.log(JSON.stringify(e))
      res.status(500).json({ message: e.message })
    }
  }
}
