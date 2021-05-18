import { NextApiRequest, NextApiResponse } from 'next'
import { getCategories } from '../../saleor/api/category'

export default async function plp(req: NextApiRequest, res: NextApiResponse) {
  const categories = await getCategories()

  res.json(categories)
}
