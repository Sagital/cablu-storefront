import { getProductVariant } from '../../../saleor/api/product'

export default async function pdp(req, res) {
  const { productId } = req.query

  const productVariant = await getProductVariant(productId)

  const pageData = {
    pageData: {
      title: 'Page Title',
      product: productVariant,
    },
  }

  return res.json(pageData)
}
