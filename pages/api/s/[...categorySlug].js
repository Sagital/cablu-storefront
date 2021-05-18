import { ApolloClient, gql, InMemoryCache } from '@apollo/client'
import categoryQuery from './queries'
import qs from 'qs'
import { convertProduct } from '../../../saleor/converters'
export default async function plp(req, res) {
  // Note: the structure of the query string is controlled by the queryForState prop passed
  // to SearchResultsProvider in pages/s/[...categorySlug].js.
  const { categorySlug: slug } = req.query

  const params = qs.parse(req.query)

  const filter = {}

  Object.keys(params).forEach(k => {
    if (k.startsWith('filter_')) {
      filter[k] = params[k]
    } else if (k === 'sort') {
    }
  })

  const client = new ApolloClient({
    uri: 'https://api.cablu.io/graphql/',
    cache: new InMemoryCache(),
  })

  // dunno why this comes as an array
  const theSlug = slug[0]

  const variables = {
    slug: theSlug,
  }

  const result = await client.query({
    query: gql`
      ${categoryQuery}
    `,
    variables,
  })

  const categoryFilters = []

  const x = {
    pageData: {
      id: ['1'],
      name: 'Subcategory 1',
      title: 'Subcategory 1',
      total: 100,
      page: 0,
      category: result.data.category,
      totalPages: 5,
      filters: categoryFilters || [],
      sortOptions: [
        {
          name: 'Price - Lowest',
          code: 'price_asc',
        },
        {
          name: 'Price - Highest',
          code: 'price_desc',
        },
        {
          name: 'Most Popular',
          code: 'pop',
        },
        {
          name: 'Highest Rated',
          code: 'rating',
        },
      ],
      breadcrumbs: [
        {
          text: 'Home',
          href: '/',
        },
      ],
    },
  }

  const category = result.data.category

  x.pageData.id = [category.id]
  x.pageData.name = category.name
  x.pageData.title = category.title

  x.pageData.products = category.products.edges
    .map(edge => edge.node)
    .filter(p => p.defaultVariant !== null)
    .map(convertProduct)

  res.json(x)
}
