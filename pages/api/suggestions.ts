import { NextApiRequest, NextApiResponse } from 'next'
import { searchProducts } from '../../saleor/api/product'

export default async function plp(req: NextApiRequest, res: NextApiResponse) {
  let { categoryId, searchTerm, limit = 100 } = req.body

  const searchResults = await searchProducts({ categoryId, searchTerm, limit })

  res.json(searchResults)
}
