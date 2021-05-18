import { getProducts } from '../../saleor/api/product'
import { NextApiRequest, NextApiResponse } from 'next'

export default async function plp(req: NextApiRequest, res: NextApiResponse) {

  const { categoryIds, filters, sort } = req.body

  // @ts-ignore
  const products = await getProducts(categoryIds, filters, sort)

  res.json(products)
}
