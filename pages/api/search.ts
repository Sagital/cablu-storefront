import { NextApiRequest, NextApiResponse } from 'next'
import { searchProducts } from '../../saleor/api/product'

import qs from 'qs'

export default async function plp(req: NextApiRequest, res: NextApiResponse) {
  let params = qs.parse(req.query as Record<string, string>)

  let { categoryId, searchTerm, limit = 100 } = params

  // @ts-ignore
  const searchResults = await searchProducts({ categoryId, searchTerm, limit })

  res.json({ pageData: { products: searchResults } })
}
