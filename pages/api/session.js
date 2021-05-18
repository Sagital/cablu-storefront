import { readCartTokenCookie } from '../../saleor/cookies'
import { getCheckout } from '../../saleor/api/checkout'
import { getShopConfiguration } from '../../saleor/api/shop'

export default async function(req, res) {
  const cartToken = readCartTokenCookie(req)

  if (cartToken) {
    let [checkout, shop] = await Promise.all([getCheckout(cartToken), getShopConfiguration()])

    return res.json({
      checkout,
      availablePaymentMethods: shop.availablePaymentGateways,
      availableShippingMethods: shop.availableShippingMethods,
    })
  } else {
    let shop = await getShopConfiguration()
    return res.json({
      availablePaymentMethods: shop.availablePaymentGateways,
      availableShippingMethods: shop.availableShippingMethods,
    })
  }
}
