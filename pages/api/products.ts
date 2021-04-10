import qs from 'qs'
import { getProducts } from '../../saleor/api/product'
import { NextApiRequest, NextApiResponse } from 'next'

export default async function plp(req: NextApiRequest, res: NextApiResponse) {
  const params: { [p: string]: unknown } = qs.parse(req.query as Record<string, string>)

  // @ts-ignore
  const products = await getProducts(params)

  res.json({ products: products })
}
