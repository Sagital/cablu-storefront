import gql from 'graphql-tag'
import { PRODUCT_VARIANT_QUERY, PRODUCTS_QUERY } from './queries/product'
import {
  OrderDirection,
  Product,
  ProductCountableConnection,
  ProductFilterInput,
  ProductOrder,
  ProductOrderField,
  ProductVariant,
} from '../graphql'
import client from '../apolloClient'
import { convertProduct, convertProductVariant } from '../converters'

export const getProductVariant = async (id: string) => {
  const variables = {
    id,
  }

  const response = await client.query<{ productVariant: ProductVariant }>({
    query: gql`
      ${PRODUCT_VARIANT_QUERY}
    `,
    variables,
  })

  return convertProductVariant(response.data.productVariant)
}

export const getProducts = async (params: { [key: string]: string[] }) => {
  const productFilterInput: ProductFilterInput = {
    attributes: [],
  }

  const sortBy: ProductOrder = { direction: OrderDirection.Asc, field: ProductOrderField.Type }

  Object.keys(params).forEach(k => {
    if (k === 'filter_category-id') {
      // @ts-ignore
      productFilterInput.categories = [params[`filter_category-id`]]
    } else if (k.startsWith('filter_')) {
      productFilterInput.attributes?.push({
        slug: k.substring('filter_'.length),
        values: params[k],
      })
    } else if (k === 'sort') {
      // @ts-ignore
      const [field, direction] = params[k].split('_')

      sortBy.field = field.toUpperCase()
      sortBy.direction = direction.toUpperCase()
    }
  })

  const variables = {
    first: 100,
    after: '',
    filter: productFilterInput,
    sortBy,
  }

  const response = await client.query<{ products: ProductCountableConnection }>({
    query: gql`
      ${PRODUCTS_QUERY}
    `,
    variables,
  })

  return response.data.products.edges
    .filter(e => e.node.defaultVariant !== null)
    .map(e => convertProduct(e.node))
}
