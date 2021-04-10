import { readCartTokenCookie } from '../../saleor/cookies'
import { convertShippingPrice, convertTotalPrice } from '../../saleor/converters'
import { getCheckout } from '../../saleor/api/checkout'
import { getShopConfiguration } from '../../saleor/api/shop'

export default async function(req, res) {
  const cartToken = readCartTokenCookie(req)

  if (cartToken) {
    let [checkout, shop] = await Promise.all([getCheckout(cartToken), getShopConfiguration()])
    const { cart, itemsInCart, shippingAddress, billingAddress, email } = convertCheckout(checkout)
    return res.json({
      cart,
      email,
      itemsInCart,
      shippingPrice: convertShippingPrice(checkout.shippingPrice),
      totalPrice: convertTotalPrice(checkout.totalPrice),
      shippingMethodId: checkout.shippingMethod ? checkout.shippingMethod.id : null,
      availablePaymentMethods: shop.availablePaymentGateways,
      availableShippingMethods: shop.availableShippingMethods,
      shippingAddress,
      billingAddress,
    })
  } else {
    let shop = await getShopConfiguration()
    return res.json({
      cart: {},
      itemsInCart: 0,

      availablePaymentMethods: shop.availablePaymentGateways,
      availableShippingMethods: shop.availableShippingMethods,
    })
  }
}
